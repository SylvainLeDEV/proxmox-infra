terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.7.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://${var.proxmox_ip}:8006/api2/json"
  api_token = var.api_token
  insecure = true
  ssh {
    agent    = true
    username = "root"
    private_key = file("~/.ssh/id_ed25519")
  }
}