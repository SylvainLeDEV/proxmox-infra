output "vm_ip" {
  value = module.vm.ipv4_addresses[0]
}