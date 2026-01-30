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

# Primary IPv4 address - take first non-localhost IP
output "ipv4_addresses" {
  description = "Primary IPv4 address (first valid IP)"
  value = try(
    [
      for ip in flatten(proxmox_virtual_environment_vm.vm.ipv4_addresses) :
      ip
      if ip != "127.0.0.1" && !startswith(ip, "169.254.")
    ][0],
    null
  )
}

output "debug_ssh_public_key" {
  value     = local.ssh_public_key
  sensitive = true
}