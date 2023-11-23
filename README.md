# Packer Debian 12 (Bookworm) Template for Proxmox
Packer configuration for creating Debian 12 virtual machine templates for Proxmox VE.

## Requirements
- [Packer](https://www.packer.io/downloads)
- [Proxmox VE](https://www.proxmox.com/en/proxmox-ve)

## Creating a new VM Template
```sh
packer build -var-file example-variables.pkrvars.hcl .
```

## Connecting with cloned VM over SSH
Change the IP with your VM's IP

```sh
ssh root@10.0.0.226
```

Then use the password "packer".