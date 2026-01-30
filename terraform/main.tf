# =============================================================================
# Proxmox Infrastructure - Root Module
# =============================================================================
# This module orchestrates the deployment of virtual machines on Proxmox VE.
# Uses reusable modules for better maintainability and scalability.
# =============================================================================

module "vm_reverse_proxy" {
  source = "./modules/vm"

  proxmox_node     = var.proxmox_node
  template_tag     = var.template_tag

  vm_config = {
    hostname = "reverse-proxy"
    domain   = var.domain
    on_boot  = true
    tags     = ["reverse-proxy"]

    cpu = {
      cores   = 2
      sockets = 1
    }

    memory = 4096

    disk = {
      storage = "local-lvm"
      size    = 10
    }

    cloud_init = {
      enabled = true
      user    = "ubuntu"
    }
  }
}

# Example VM Deployment - Database Server
# Uncomment and modify as needed for additional VMs
#
# module "vm_database" {
#   source = "./modules/vm"
#
#   proxmox_node     = var.proxmox_node
#   template_tag     = var.template_tag
#
#   vm_config = {
#     hostname = "database"
#     domain   = var.domain
#     on_boot  = true
#     tags     = ["database", "production"]
#
#     cpu = {
#       cores   = 8
#       sockets = 2
#     }
#
#     memory = 16384
#
#     disk = {
#       storage = "local-lvm"
#       size    = 100
#     }
#
#     additional_disks = [
#       {
#         storage = "local-lvm"
#         size    = 200
#       }
#     ]
#
#     cloud_init = {
#       enabled = true
#       user    = "sysadmin"
#     }
#   }
# }
