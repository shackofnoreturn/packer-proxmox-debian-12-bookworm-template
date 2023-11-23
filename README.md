# Packer Debian 12 (Bookworm) Template for Proxmox
Packer configuration for creating Debian 12 virtual machine templates for Proxmox VE.

## Requirements
- [Packer](https://www.packer.io/downloads)
- [Proxmox VE](https://www.proxmox.com/en/proxmox-ve)

## Why
Time and time again you create a VM and go through the setup manually.
This method automatically goes through all manual options using a preseed.

More info on preseeding: [preseed documentation](https://wiki.debian.org/DebianInstaller/Preseed)

## How
### 1. Creating a new VM Template
Templates are created by converting an existing VM to a template.
Navigate to the project directory and execute the following command:

```sh
packer build -var-file example-variables.pkrvars.hcl .
```

### 2. Deploy a VM from a Template
Right-click the template in Proxmox VE, and select "Clone".

- **full clone** is a complete copy and is fully independent from the original VM or VM Template, but it requires the same disk space as the original
- **linked clone** requires less disk space but cannot run without access to the base VM Template. Not supported with LVM & ISCSI storage types


### 3. Connect with cloned VM over SSH
(*Change the IP with your VM's IP*)

```sh
ssh root@10.0.0.226
```

Then use the password "packer".

## Customize
We don't want identical clones. 
They all need different hostnames, ip addresses, etc ...
This is what cloud-init is used for to provide an initial configuration.

- creating users
- preseeding `authorized_keys` file for SSH authentication (not yet implemented)

More info on cloud-init: [cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/)

### Variables
**Tip!**
Packer automatically loads any var file that matches the name `*.auto.pkrvars.hcl`, without the need to pass the file via the command line. If you rename the example variable definitions file from `example-variables.pkrvars.hcl` to `example-variables.auto.pkrvars.hcl`, then you can run the build just by calling:

```sh
$ packer build .
```
