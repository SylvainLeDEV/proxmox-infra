# Auto-generate an Ansible inventory from Terraform-created VMs.
#
# Expected root module pattern:
#   module "vms" {
#     source  = "./modules/vm"
#     for_each = var.vms
#     vm_config = each.value
#     ...
#   }
#
# Expected module outputs (per VM):
#   - hostname (string)
#   - ipv4_addresses (list(string))
#   - ansible_user (string, optional)
#   - ansible_groups (list(string), optional)  # e.g. ["reverse_proxy", "dmz"]

# locals {
#   # Flatten module outputs into a simple host map
#   hosts = {
#     for _, m in module.vms :
#     m.hostname => {
#       ansible_host   = try(m.ipv4_addresses[0], null)
#       ansible_user   = try(m.ansible_user, "ubuntu")
#       ansible_groups = try(m.ansible_groups, [])
#     }
#   }

#   # Build children groups automatically from each host's ansible_groups
#   all_groups = distinct(flatten([for h in values(local.hosts) : h.ansible_groups]))

#   children = {
#     for g in local.all_groups : g => {
#       hosts = {
#         for name, h in local.hosts : name => {
#           ansible_host = h.ansible_host
#           ansible_user = h.ansible_user
#         } if contains(h.ansible_groups, g)
#       }
#     }
#   }

#   # Inventory structure (also keeps a flat `all.hosts` list)
#   inventory = {
#     all = {
#       hosts    = { for name, h in local.hosts : name => { ansible_host = h.ansible_host, ansible_user = h.ansible_user } }
#       children = local.children
#     }
#   }
# }

# resource "local_file" "ansible_inventory" {
#   filename = "${path.root}/../ansible/inventory.yml"
#   content  = yamlencode(local.inventory)
# }