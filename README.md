# Proxmox Infrastructure as Code

Terraform modules for automated virtual machine deployment on Proxmox VE.

## 📁 Directory Structure

```
proxmox-infra/
├── terraform/                          # Main Terraform configuration
│   ├── main.tf                        # Root module - VM orchestration
│   ├── variables.tf                   # Root variables (3 vars)
│   ├── providers.tf                   # Proxmox provider config
│   ├── output.tf                      # Root outputs
│   ├── examples.tf                    # Example configurations
│   │
│   ├── modules/
│   │   ├── vm/                        # ⭐ Reusable VM Module (Core)
│   │   │   ├── main.tf                # VM resources
│   │   │   ├── variables.tf           # VM config with validation
│   │   │   ├── outputs.tf             # Module outputs
│   │   │   ├── README.md              # Module documentation
│   │   │   └── templates/
│   │   │       ├── user_data.yaml     # Cloud-init user data
│   │   │       └── meta_data.yaml     # Cloud-init metadata
│   │   ├── network/                   # Network module (placeholder)
│   │   └── storage/                   # Storage module (placeholder)
│   │
│   ├── environments/
│   │   ├── dev/terraform.tfvars       # Dev environment
│   │   └── prod/terraform.tfvars      # Prod environment
│   │
│   └── cloud-init/
│       ├── user_data.yaml             # Global user data
│       └── meta_data.yaml             # Global metadata
│
├── templates/
│   └── ubuntu/24.04/                  # Ubuntu 24.04 template
│       ├── build.sh
│       ├── cloudinit.yml
│       └── README.md
│
└── README.md                          # This file
```

## ⚡ Quick Start

### Setup

```bash
# 1. Set API token
export TF_VAR_api_token="PVEAPIToken=user@pam!tokenname:token-uuid"

# 2. Navigate to terraform
cd terraform

# 3. Initialize
terraform init

# 4. Plan (dev environment)
terraform plan -var-file=environments/dev/terraform.tfvars

# 5. Deploy
terraform apply -var-file=environments/dev/terraform.tfvars
```

## 🚀 Deploying VMs

### Basic VM (Minimal Config)

```hcl
module "vm_example" {
  source = "./modules/vm"
  proxmox_node = var.proxmox_node
  template_tag = var.template_tag
  
  vm_config = {
    hostname = "example"
    domain   = var.domain
  }
}
```

### Web Server (4 CPU, 4GB RAM, 20GB disk)

```hcl
module "vm_web" {
  source = "./modules/vm"
  proxmox_node = var.proxmox_node
  template_tag = var.template_tag
  
  vm_config = {
    hostname = "web"
    domain   = var.domain
    tags     = ["web", "production"]
    cpu      = { cores = 4 }
    memory   = 4096
    disk     = { size = 20 }
  }
}
```

## 🔧 Essential Commands

```bash
# Validate configuration
terraform validate

# See what will change (dry-run)
terraform plan -var-file=environments/dev/terraform.tfvars

# Deploy VMs
terraform apply -var-file=environments/dev/terraform.tfvars

# Destroy specific VM
terraform destroy -target="module.vm_web" -var-file=environments/dev/terraform.tfvars

# Destroy all VMs
terraform destroy -var-file=environments/dev/terraform.tfvars

# View outputs
terraform output

# View specific module outputs
terraform output -json 'module.vm_web'

# Switch to production environment
terraform plan -var-file=environments/prod/terraform.tfvars
```

## 📋 VM Configuration Reference

All fields are optional except `hostname`:

```hcl
vm_config = {
  hostname = "myvm"              # Required - VM name
  domain   = "example.com"       # Optional - creates FQDN
  on_boot  = true                # Optional - auto-start on boot
  tags     = ["web", "prod"]     # Optional - classification tags
  
  cpu = {
    type    = "x86-64-v2-AES"    # CPU type (default)
    cores   = 2                  # CPU cores (default: 2)
    sockets = 1                  # CPU sockets (default: 1)
  }
  
  memory = 2048                  # RAM in MB (default: 2048)
  
  disk = {
    storage = "local-lvm"        # Storage pool (default: local-lvm)
    size    = 10                 # Size in GB (default: 10)
  }
  
  additional_disks = [
    { storage = "local-lvm", size = 50 }
  ]
  
  network = {
    bridge = "vmbr0"             # Network bridge (default: vmbr0)
    model  = "virtio"            # NIC model (default: virtio)
  }
  
  cloud_init = {
    enabled = true               # Enable provisioning (default: true)
    user    = "sysadmin"         # Default user (default: sysadmin)
  }
}
```

## 🔐 Environment Setup

### Set API Token (Required)

```bash
# Generate token on Proxmox node:
pveum user add terraform@pam
pveum acl modify / -user terraform@pam -role Administrator
pveum user token add terraform@pam terraform --privsep=0

# Set in shell (Linux/Mac):
export TF_VAR_api_token="PVEAPIToken=terraform@pam!terraform:your-token-uuid"
```
