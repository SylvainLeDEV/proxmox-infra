# 🏗️ Home Lab Architecture – Reverse Proxy Based Design

## 🎯 Goal

Design a **clean, scalable, and secure home-lab architecture** to expose multiple self-hosted applications
(Jellyfin, monitoring tools, internal services, etc.) to the Internet using:

- One public domain name
- Multiple subdomains
- A single reverse proxy (Nginx)
- Multiple backend VMs and containers
- Proxmox as the virtualization platform

This document is **conceptual** and serves as the architectural reference for the lab.

---

## 🌍 High-Level Overview

All external traffic enters through **one single point**: the reverse proxy.

```
Internet
   ↓
Domain name (example.com)
   ↓
DNS
   ↓
Public IP (ISP / Router)
   ↓
NAT / Port Forwarding (80, 443)
   ↓
Reverse Proxy VM (Nginx)
   ↓
Internal Network
   ↓
Backend VMs / Containers
```

---

## 🌐 Domain & DNS Strategy

### Domain
A single domain is purchased from a registrar (e.g. `example.com`).

### Subdomains
Each application is exposed using its own subdomain:

| Application | Subdomain |
|------------|-----------|
| Jellyfin | jellyfin.example.com |
| Grafana | grafana.example.com |
| Git | git.example.com |
| Vault | vault.example.com |

### DNS Records
All subdomains point to **the same public IP**:

```
*.example.com → Public_IP
```

DNS **does not know** where applications run internally.  
It only routes traffic to the home network.

---

## 🔁 Reverse Proxy (Nginx)

### Role
The reverse proxy is the **central routing and security component**.

Responsibilities:
- Terminates HTTPS (TLS)
- Routes traffic based on the `Host` header
- Forwards requests to the correct backend service
- Acts as a security buffer between Internet and internal services

### Why a Dedicated VM
- Clear separation of concerns
- Easier security hardening
- Stable entry point for the entire infrastructure

---

## 🔀 Traffic Routing Logic

Incoming HTTPS requests are routed based on the hostname:

| Incoming Host | Forwarded To |
|--------------|-------------|
| jellyfin.example.com | VM Jellyfin (192.168.x.x:8096) |
| grafana.example.com | VM Monitoring (192.168.x.x:3000) |
| git.example.com | Docker container (192.168.x.x:3000) |

The reverse proxy only needs:
- Internal IP
- Port

Backend location (VM, container, host) is irrelevant.

---

## 🖥️ Backend Services

Backend applications can run on:
- Dedicated VMs
- Docker containers
- Different Proxmox nodes
- Separate VLANs (optional)

They:
- Are **never exposed directly** to the Internet
- Communicate with the reverse proxy over the internal network
- Usually run in plain HTTP internally

---

## 🔐 HTTPS & Certificates

HTTPS is handled **only** by the reverse proxy.

Possible strategies:
- One certificate per subdomain
- One wildcard certificate (`*.example.com`)

Advantages:
- Centralized TLS management
- Automatic renewal (Let’s Encrypt)
- No SSL configuration inside applications

---

## 🛡️ Security Principles

- Only ports **80/443** are exposed to the Internet
- No direct access to backend services
- Proxmox management interface is **never exposed**
- Reverse proxy can implement:
  - Authentication
  - Rate limiting
  - IP filtering
  - WAF rules

---

## 🧠 Key Takeaways

- DNS routes traffic **to your home**, not to applications
- The reverse proxy is the **single Internet-facing component**
- Subdomains scale infinitely with zero DNS complexity
- Backend services are isolated, replaceable, and movable

---

## 🚀 Next Steps

- Implement Nginx reverse proxy
- Add HTTPS with Let’s Encrypt
- Deploy Jellyfin behind the proxy
- Extend to additional services
- Introduce network segmentation (VLANs)

This document is the **foundation** of the home-lab architecture.
