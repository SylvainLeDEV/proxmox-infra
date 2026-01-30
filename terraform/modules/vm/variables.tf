variable "vm_config" {
  description = "VM configuration"
  type = object({
    hostname = string
    domain   = optional(string, "")
    on_boot  = optional(bool, true)
    tags     = optional(list(string), [])

    # CPU Configuration
    cpu = optional(object({
      type    = optional(string, "x86-64-v2-AES")
      cores   = optional(number, 2)
      sockets = optional(number, 1)
    }), {})

    # Memory Configuration (in MB)
    memory = optional(number, 2048)

    # Primary Disk Configuration
    disk = optional(object({
      storage = optional(string, "local-lvm")
      size    = optional(number, 10)
    }), {})

    # Additional Disks
    additional_disks = optional(list(object({
      storage = string
      size    = number
    })), [])

    # Network Configuration
    network = optional(object({
      bridge = optional(string, "vmbr0")
      model  = optional(string, "virtio")
    }), {})

    # Cloud-init Configuration
    cloud_init = optional(object({
      enabled = optional(bool, true)
      user    = optional(string, "sysadmin")
    }), {})
  })

  validation {
    condition     = var.vm_config.cpu.cores > 0
    error_message = "CPU cores must be greater than 0."
  }

  validation {
    condition     = var.vm_config.memory > 0
    error_message = "Memory must be greater than 0."
  }

  validation {
    condition     = var.vm_config.disk.size > 0
    error_message = "Disk size must be greater than 0."
  }
}

variable "proxmox_node" {
  description = "Target Proxmox node name"
  type        = string
}

variable "template_tag" {
  description = "Template tag to identify source template VM"
  type        = string
  default     = "template"
}

variable "template_name_filter" {
  description = "Optional filter for template name (regex)"
  type        = string
  default     = ""
}
