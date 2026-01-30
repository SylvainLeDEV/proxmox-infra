terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.7.0"
    }
  }
}

locals {
  full_hostname = var.vm_config.domain != "" ? "${var.vm_config.hostname}.${var.vm_config.domain}" : var.vm_config.hostname

  # Read SSH public key from local machine
  ssh_public_key = try(file("~/.ssh/id_rsa.pub"), try(file("~/.ssh/id_ed25519.pub"), ""))

  # Default CPU configuration
  cpu_config = merge(
    {
      type    = "x86-64-v2-AES"
      cores   = 2
      sockets = 1
    },
    var.vm_config.cpu
  )

  # Default network configuration
  network_config = merge(
    {
      bridge = "vmbr0"
      model  = "virtio"
    },
    var.vm_config.network
  )

  # Default disk configuration
  disk_config = merge(
    {
      storage = "local-lvm"
      size    = 10
    },
    var.vm_config.disk
  )

  # Default cloud-init configuration
  cloud_init_config = merge(
    {
      enabled = true
      user    = "ubuntu"
      wait_for_ip = {
        ipv4 = true
      }
    },
    var.vm_config.cloud_init
  )
}

# Data source to find template VM
data "proxmox_virtual_environment_vms" "template" {
  node_name = var.proxmox_node
  tags      = [var.template_tag]
}

# Cloud-init User Data Configuration
resource "proxmox_virtual_environment_file" "cloud_user_config" {
  count = local.cloud_init_config.enabled ? 1 : 0

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    data = templatefile("${path.module}/cloud-init/user_data.yaml", {
      hostname       = var.vm_config.hostname
      domain         = var.vm_config.domain
      username       = local.cloud_init_config.user
      ssh_public_key = local.ssh_public_key
    })

    file_name = "${local.full_hostname}-ci-user.yml"
  }
}

# Cloud-init Metadata Configuration
resource "proxmox_virtual_environment_file" "cloud_meta_config" {
  count = local.cloud_init_config.enabled ? 1 : 0

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    data = templatefile("${path.module}/cloud-init/meta_data.yaml", {
      instance_id    = sha1(var.vm_config.hostname)
      local_hostname = var.vm_config.hostname
    })

    file_name = "${local.full_hostname}-ci-meta.yml"
  }
}

# Main Virtual Machine Resource
resource "proxmox_virtual_environment_vm" "vm" {
  name      = local.full_hostname
  node_name = var.proxmox_node
  on_boot   = var.vm_config.on_boot
  tags      = var.vm_config.tags

  # Clone from template - this ensures bootable disk
  clone {
    vm_id = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
  }

  # QEMU Agent
  agent {
    enabled = true
  }

  # CPU Configuration
  cpu {
    type    = local.cpu_config.type
    cores   = local.cpu_config.cores
    sockets = local.cpu_config.sockets
  }

  # Memory Configuration
  memory {
    dedicated = var.vm_config.memory
  }

  # Primary Network Interface
  network_device {
    bridge = local.network_config.bridge
    model  = local.network_config.model
  }

  # Boot Configuration
  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-single"

  # Primary Disk - Resize the cloned disk to desired size
  disk {
    interface    = "scsi0"
    iothread     = true
    datastore_id = local.disk_config.storage
    size         = local.disk_config.size
    discard      = "ignore"
  }

  # Additional Disks - Dynamic Block (if needed)
  dynamic "disk" {
    for_each = var.vm_config.additional_disks
    content {
      interface    = "scsi${1 + disk.key}"
      iothread     = true
      datastore_id = disk.value.storage
      size         = disk.value.size
      discard      = "ignore"
    }
  }

  # Cloud-init Initialization
  dynamic "initialization" {
    for_each = local.cloud_init_config.enabled ? [1] : []
    content {
      user_data_file_id = proxmox_virtual_environment_file.cloud_user_config[0].id
      meta_data_file_id = proxmox_virtual_environment_file.cloud_meta_config[0].id
    }
  }

  # Lifecycle Rules
  lifecycle {
    ignore_changes = [network_device]
  }

  # Dependencies
  depends_on = [
    proxmox_virtual_environment_file.cloud_user_config,
    proxmox_virtual_environment_file.cloud_meta_config
  ]
}
