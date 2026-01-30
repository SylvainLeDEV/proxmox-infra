resource "local_file" "ansible_inventory" {
  filename = "${path.root}/../ansible/inventory.yml"

  content = yamlencode({
    all = {
      children = {
        reverse_proxy = {
          hosts = module.vm_reverse_proxy.ipv4_addresses != null ? {
            (module.vm_reverse_proxy.vm_fqdn) = {
              ansible_host = module.vm_reverse_proxy.ipv4_addresses
              ansible_user = "ubuntu"
            }
          } : {}
        }
      }
    }
  })
}

// Pour ajouter d'autres VMs à l'inventaire, tu peux étendre la structure comme ceci :
// reverse_proxy = {
//   hosts = length(module.vm_reverse_proxy.ipv4_addresses) > 0 ? {
//     (module.vm_reverse_proxy.vm_fqdn) = {
//       ansible_host = module.vm_reverse_proxy.ipv4_addresses[0]
//       ansible_user = "ubuntu"
//     }
//   } : {}
// }
// media = {
//   hosts = length(module.media.ipv4_addresses) > 0 ? {
//     (module.media.vm_fqdn) = {
//       ansible_host = module.media.ipv4_addresses[0]
//       ansible_user = "ubuntu"
//     }
//   } : {}
// }