#!/usr/bin/env bash
#
# build-ubuntu-2404-template.sh
# Script to build a Proxmox cloud-init template for Ubuntu 24.04 LTS
#
# Usage :
#   ./build-ubuntu-2404-template.sh \
#     --vmid 9000 \
#     --name ubuntu-24.04-cloudinit \
#     --storage local-lvm \
#     --bridge vmbr0 \
#     --mem 2048 \
#     --cores 2

set -euo pipefail

### DEFAULTS
VMID=9000
NAME="ubuntu-24.04-cloudinit"
STORAGE="local-lvm"
BRIDGE="vmbr0"
MEM=2048
CORES=2
IMG_URL="https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
IMG_FILE="ubuntu-24.04-server-cloudimg-amd64.img"

# Cloud-Init default user (BOOTSTRAP ONLY)
# This user/password is meant for initial access and troubleshooting.
# ⚠️ Do NOT keep this in production: switch to SSH keys as soon as possible.
CI_USER="ubuntu"
CI_PASSWORD="changeme"

### PARSE ARGS
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vmid) VMID="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    --storage) STORAGE="$2"; shift 2;;
    --bridge) BRIDGE="$2"; shift 2;;
    --mem) MEM="$2"; shift 2;;
    --cores) CORES="$2"; shift 2;;
    *) echo "Unknown param $1"; exit 1;;
  esac
done

echo "Building Ubuntu 24.04 cloud-init template"
echo "- VMID:     $VMID"
echo "- Name:     $NAME"
echo "- Storage:  $STORAGE"
echo "- Bridge:   $BRIDGE"
echo "- RAM:      $MEM MB"
echo "- Cores:    $CORES"
echo "- Image:    $IMG_FILE"

### MOVE TO THE ISO DIRECTORY
echo "Changing directory to /var/lib/vz/template/iso"
cd /var/lib/vz/template/iso

### DOWNLOAD IMAGE IF MISSING
if [[ ! -f $IMG_FILE ]]; then
  echo "Downloading Ubuntu 24.04 cloud image into /var/lib/vz/template/iso..."
  wget -q "$IMG_URL" -O "$IMG_FILE"
fi

# ### OPTIONAL : INSTALL GUEST AGENT INTO IMAGE
# echo "Installing qemu-guest-agent into image…"
# apt-get update -y
# apt-get install -y libguestfs-tools
# virt-customize --network -a "$IMG_FILE" --install qemu-guest-agent

### CREATE PROXMOX VM
echo "Creating proxmox VM…"
qm create "$VMID" \
  --name "$NAME" \
  --memory "$MEM" \
  --cores "$CORES" \
  --net0 virtio,bridge="$BRIDGE"

### IMPORT IMAGE AS DISK
echo "Importing disk into VM storage…"
qm importdisk "$VMID" "$IMG_FILE" "$STORAGE"

### CONFIG VM FOR CLOUD-INIT
echo "Configuring VM hardware and cloud-init…"
qm set "$VMID" \
  --scsihw virtio-scsi-pci \
  --scsi0 "$STORAGE":vm-"$VMID"-disk-0 \
  --ide2 "$STORAGE":cloudinit \
  --boot c \
  --bootdisk scsi0 \
  --serial0 socket \
  --vga serial0 \
  --agent enabled=1 \
  --ciuser "$CI_USER" \
  --cipassword "$CI_PASSWORD" \
  --ipconfig0 ip=dhcp \
  --tags "template,ubuntu24.04,cloud-init"

### MARK AS TEMPLATE
echo "Converting VM to template…"
qm template "$VMID"

echo "Template $NAME ($VMID) created!"