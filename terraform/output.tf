// Expose the reverse-proxy VM's primary IPv4 address
output "vm_reverse_proxy_ip" {
  description = "Primary IPv4 address for the reverse-proxy VM"
  value       = module.vm_reverse_proxy.ipv4_addresses
}

# Uncomment to debug SSH key
output "debug_ssh_public_key" {
  value     = module.vm_reverse_proxy.debug_ssh_public_key
  sensitive = true
}