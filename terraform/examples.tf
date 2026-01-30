# =============================================================================
# Example: Multi-VM Infrastructure Setup
# =============================================================================
#
# This file demonstrates how to create a complete infrastructure with multiple
# VMs using the optimized module structure. Copy and adapt for your needs.
#
# USAGE:
# 1. Copy this file to a new name (e.g., main-example.tf)
# 2. Modify vm_config values as needed
# 3. Run: terraform plan -var-file=environments/dev/terraform.tfvars
#
# =============================================================================

# Web Server - Frontend
# module "vm_webserver" {
#   source = "./modules/vm"
#
#   proxmox_node = var.proxmox_node
#   template_tag = var.template_tag
#
#   vm_config = {
#     hostname = "webserver"
#     domain   = var.domain
#     on_boot  = true
#     tags     = ["web", "frontend", "production"]
#
#     cpu = {
#       type    = "x86-64-v2-AES"
#       cores   = 4
#       sockets = 1
#     }
#
#     memory = 4096
#
#     disk = {
#       storage = "local-lvm"
#       size    = 20
#     }
#
#     additional_disks = [
#       {
#         storage = "local-lvm"
#         size    = 50
#       }
#     ]
#
#     network = {
#       bridge = "vmbr0"
#       model  = "virtio"
#     }
#
#     cloud_init = {
#       enabled = true
#       user    = "sysadmin"
#     }
#   }
# }
#
# # Output from web server
# output "webserver_info" {
#   value = {
#     id    = module.vm_webserver.vm_id
#     name  = module.vm_webserver.vm_name
#     fqdn  = module.vm_webserver.vm_fqdn
#     node  = module.vm_webserver.vm_node
#     cpu   = module.vm_webserver.vm_cpu_cores
#     ram   = module.vm_webserver.vm_memory_mb
#   }
# }

# =============================================================================

# Application Server
# module "vm_appserver" {
#   source = "./modules/vm"
#
#   proxmox_node = var.proxmox_node
#   template_tag = var.template_tag
#
#   vm_config = {
#     hostname = "appserver"
#     domain   = var.domain
#     on_boot  = true
#     tags     = ["app", "backend", "production"]
#
#     cpu = {
#       cores   = 6
#       sockets = 1
#     }
#
#     memory = 8192
#
#     disk = {
#       size = 30
#     }
#
#     additional_disks = [
#       {
#         storage = "local-lvm"
#         size    = 100
#       }
#     ]
#
#     cloud_init = {
#       enabled = true
#       user    = "sysadmin"
#     }
#   }
# }

# =============================================================================

# Database Server
# module "vm_database" {
#   source = "./modules/vm"
#
#   proxmox_node = var.proxmox_node
#   template_tag = var.template_tag
#
#   vm_config = {
#     hostname = "database"
#     domain   = var.domain
#     on_boot  = true
#     tags     = ["database", "backend", "production"]
#
#     cpu = {
#       cores   = 8
#       sockets = 2
#     }
#
#     memory = 16384
#
#     disk = {
#       size = 50
#     }
#
#     additional_disks = [
#       {
#         storage = "local-lvm"
#         size    = 200
#       },
#       {
#         storage = "local-lvm"
#         size    = 150
#       }
#     ]
#
#     cloud_init = {
#       enabled = true
#       user    = "sysadmin"
#     }
#   }
# }

# =============================================================================

# Development VM
# module "vm_dev" {
#   source = "./modules/vm"
#
#   proxmox_node = var.proxmox_node
#   template_tag = var.template_tag
#
#   vm_config = {
#     hostname = "dev"
#     domain   = var.domain
#     on_boot  = false
#     tags     = ["development", "test"]
#
#     cpu = {
#       cores = 2
#     }
#
#     memory = 2048
#
#     disk = {
#       size = 15
#     }
#
#     cloud_init = {
#       enabled = true
#       user    = "sysadmin"
#     }
#   }
# }

# =============================================================================

# CI/CD Server
# module "vm_cicd" {
#   source = "./modules/vm"
#
#   proxmox_node = var.proxmox_node
#   template_tag = var.template_tag
#
#   vm_config = {
#     hostname = "cicd"
#     domain   = var.domain
#     on_boot  = true
#     tags     = ["cicd", "devops", "production"]
#
#     cpu = {
#       cores   = 4
#       sockets = 1
#     }
#
#     memory = 4096
#
#     disk = {
#       size = 30
#     }
#
#     additional_disks = [
#       {
#         storage = "local-lvm"
#         size    = 100
#       }
#     ]
#
#     cloud_init = {
#       enabled = true
#       user    = "sysadmin"
#     }
#   }
# }

# =============================================================================

# Monitoring Server
# module "vm_monitoring" {
#   source = "./modules/vm"
#
#   proxmox_node = var.proxmox_node
#   template_tag = var.template_tag
#
#   vm_config = {
#     hostname = "monitoring"
#     domain   = var.domain
#     on_boot  = true
#     tags     = ["monitoring", "devops", "production"]
#
#     cpu = {
#       cores = 4
#     }
#
#     memory = 4096
#
#     disk = {
#       size = 30
#     }
#
#     additional_disks = [
#       {
#         storage = "local-lvm"
#         size    = 100
#       }
#     ]
#
#     cloud_init = {
#       enabled = true
#       user    = "sysadmin"
#     }
#   }
# }

# =============================================================================
# Outputs
# =============================================================================

# Uncomment to see VM information:
#
# output "infrastructure_overview" {
#   value = {
#     webserver = {
#       fqdn = module.vm_webserver.vm_fqdn
#       id   = module.vm_webserver.vm_id
#     }
#     appserver = {
#       fqdn = module.vm_appserver.vm_fqdn
#       id   = module.vm_appserver.vm_id
#     }
#     database = {
#       fqdn = module.vm_database.vm_fqdn
#       id   = module.vm_database.vm_id
#     }
#     monitoring = {
#       fqdn = module.vm_monitoring.vm_fqdn
#       id   = module.vm_monitoring.vm_id
#     }
#   }
#   description = "Infrastructure overview"
# }
