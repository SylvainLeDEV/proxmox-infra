variable "proxmox_ip" {
  description = "Proxmox VE IP address for API access"
  type = string
  default = "192.168.1.32"
}

variable "api_token" {
  description = "Token to connect Proxmox API"
  type = string
}

variable "target_node" {
  description = "Proxmox node"
  type        = string
  default = "pve"
}

variable "onboot" {
  description = "Auto start VM when node is start"
  type        = bool
  default     = true
}

variable "target_node_domain" {
  description = "Proxmox node domain"
  type        = string
  default = ""
}

variable "vm_hostname" {
  description = "VM hostname"
  type        = string
  default = "test"
}

variable "domain" {
  description = "VM domain"
  type        = string
  default = ""
}

variable "vm_tags" {
  description = "VM tags"
  type        = list(string)
  default = [ "ubuntu" ]
}

variable "template_tag" {
  description = "Template tag"
  type        = string
  default = "template"
}

variable "sockets" {
  description = "Number of sockets"
  type        = number
  default     = 1
}

variable "cores" {
  description = "Number of cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Number of memory in MB"
  type        = number
  default     = 2048
}

variable "vm_user" {
  description = "User"
  type        = string
  sensitive   = true
  default = "sysadmin"
}

variable "disk" {
  description = "Disk (size in Gb)"
  type = object({
    storage = string
    size    = number
  })
  default = {
    storage = "local-lvm"
    size = 10
  }
}

variable "additionnal_disks" {
  description = "Additionnal disks"
  type = list(object({
    storage = string
    size    = number
  }))
  default = []
}