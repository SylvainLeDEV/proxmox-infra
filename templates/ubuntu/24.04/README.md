# Ubuntu 22.04 Cloud-init Template

VMID: 9000  
Storage: local-lvm  
Purpose: Base template for Terraform VMs

Do not start this VM manually.

Useful blog to init template :https://dev.to/minerninja/create-an-ubuntu-cloud-init-template-on-proxmox-the-command-line-guide-5b61?utm_source=chatgpt.com
# Ubuntu 24.04 LTS Cloud-Init Template (Proxmox)

This directory contains everything required to build a **clean, reusable, and Terraform-ready Ubuntu 24.04 LTS template** for Proxmox VE.

This document explains **why** specific components are used, not just *how*.

---

## 1. Why this Ubuntu image?

### Image URL
```bash
IMG_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
IMG_FILE="noble-server-cloudimg-amd64.img"
```

### How do we know this is the correct image?

Ubuntu publishes **official cloud images** specifically designed for cloud and virtualization platforms (OpenStack, Proxmox, VMware, etc.).

These images are available at:

```
https://cloud-images.ubuntu.com/
```

Key points:
- **`noble`** = Ubuntu 24.04 LTS (Noble Numbat)
- **`current/`** = latest patched build of this LTS
- **`cloudimg`** = preinstalled OS, no interactive installer
- **`amd64`** = x86_64 architecture (standard for Proxmox)

These images are:
- Already installed (no ISO install step)
- Optimized for fast boot
- Designed to work with **cloud-init**
- Stateless by default (perfect for templates)

➡️ This is why Terraform + Proxmox workflows always start from a *cloud image*.

---

## 2. What is cloud-init?

### Definition

**cloud-init** is a standard Linux initialization system used to configure a machine **on first boot**.

It answers questions like:
- What hostname should this VM have?
- Which user should exist?
- Which SSH keys should be installed?
- How should networking be configured?
- Which commands should run once at startup?

Cloud-init runs **only once**, when the VM boots for the first time.

---

### Why cloud-init is critical for templates

When you clone a VM from a template:
- All clones share the same disk
- But each VM **must become unique**

cloud-init is what makes that possible.

Without cloud-init:
- Same hostname
- Same SSH keys
- Same IP
- Same machine identity  

With cloud-init:
- Each clone is customized at boot time
- Terraform can inject configuration dynamically
- Templates stay **immutable**

---

## 3. What is `cloudinit.yml` used for?

Example file:
```yaml
#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ssh-ed25519 AAAA...

package_update: true
package_upgrade: true

packages:
  - curl
  - git
  - htop
```

### Purpose of `cloudinit.yml`

This file is **not strictly required** by Proxmox, but it is extremely useful:

- Documents the expected VM baseline
- Can be reused later with:
  - Terraform
  - Packer
  - CI pipelines
- Makes the template behavior explicit and versioned

Think of it as:
> “This is what every VM created from this template should look like.”

---

## 4. What is qemu-guest-agent?

### Definition

`qemu-guest-agent` is a service that runs **inside the VM** and allows Proxmox to communicate with the guest operating system.

It enables:
- IP address reporting
- Clean shutdown / reboot
- Filesystem freeze (for backups)
- Better VM state awareness

---

### Why install it in the template?

Because:
- Proxmox expects it for proper VM management
- Terraform relies on Proxmox API feedback
- Cloud-init + networking detection works better

Installing it **once in the template** ensures:
- All clones have it
- No manual fix later
- Consistent behavior across environments

---

## 5. Why this template is clean

This template intentionally:
- ❌ Does NOT set a root password
- ❌ Does NOT create static users
- ❌ Does NOT hardcode SSH keys
- ❌ Does NOT run application logic

Instead:
- ✔️ OS is minimal and generic
- ✔️ Customization happens via cloud-init
- ✔️ Terraform controls VM identity
- ✔️ Template remains immutable

---

## 6. Summary

This template provides:
- Ubuntu 24.04 LTS (official cloud image)
- cloud-init support
- qemu-guest-agent installed
- Proxmox-compatible hardware defaults
- A clean base for Terraform cloning

**Do not start this VM manually.**  
It exists only to be cloned.

---

## 7. References

- Ubuntu Cloud Images: https://cloud-images.ubuntu.com/
- Proxmox Cloud-Init docs: https://pve.proxmox.com/wiki/Cloud-Init_Support
- Template guide inspiration:
  https://dev.to/minerninja/create-an-ubuntu-cloud-init-template-on-proxmox-the-command-line-guide-5b61