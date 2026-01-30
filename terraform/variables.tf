# =============================================================================
# Root Variables - Proxmox Provider & Common Configuration
# =============================================================================

# Provider Configuration
variable "proxmox_ip" {
  description = "Proxmox VE IP address for API access"
  type        = string
  default     = "192.168.1.32"
}

variable "api_token" {
  description = "Proxmox API token for authentication"
  type        = string
  sensitive   = true
}

# Proxmox Node Configuration
variable "proxmox_node" {
  description = "Target Proxmox node name"
  type        = string
  default     = "pve"
}

# Domain Configuration
variable "domain" {
  description = "Domain name for VMs"
  type        = string
  default     = ""
}

# Template Configuration
variable "template_tag" {
  description = "Template tag to identify source template VM"
  type        = string
  default     = "template"
}