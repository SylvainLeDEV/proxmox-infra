output "vm_id" {
  description = "VM ID in Proxmox"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "vm_name" {
  description = "Full VM name"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_node" {
  description = "Proxmox node where VM is deployed"
  value       = proxmox_virtual_environment_vm.vm.node_name
}

output "vm_hostname" {
  description = "VM hostname"
  value       = var.vm_config.hostname
}

output "vm_domain" {
  description = "VM domain"
  value       = var.vm_config.domain
}

output "vm_fqdn" {
  description = "Fully qualified domain name"
  value       = var.vm_config.domain != "" ? "${var.vm_config.hostname}.${var.vm_config.domain}" : var.vm_config.hostname
}

output "vm_cpu_cores" {
  description = "Number of CPU cores"
  value       = local.cpu_config.cores
}

output "vm_memory_mb" {
  description = "Memory in MB"
  value       = var.vm_config.memory
}

output "vm_disk_size_gb" {
  description = "Primary disk size in GB"
  value       = local.disk_config.size
}

output "vm_tags" {
  description = "VM tags"
  value       = var.vm_config.tags
}

output "vm_ip" {
  value = proxmox_virtual_environment_vm.vm.ipv4_addresses[0]
}