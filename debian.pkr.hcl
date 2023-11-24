# Requirements
packer {
  required_plugins {
    proxmox = {
      version = "1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variables
variable "iso_file" {
  type = string
}

variable "cloudinit_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "cores" {
  type    = string
  default = "2"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "20G"
}

variable "disk_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "cpu_type" {
  type    = string
  default = "kvm64"
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "network_vlan" {
  type    = string
  default = ""
}

variable "machine_type" {
  type    = string
  default = ""
}

variable "proxmox_api_password" {
  type      = string
  sensitive = true
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_node" {
  type = string
}

# Builder
source "proxmox-iso" "debian" {
  # Proxmox
  proxmox_url              = "https://${var.proxmox_host}/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.proxmox_api_user
  password                 = var.proxmox_api_password

  # Template
  template_description     = "Built from ${basename(var.iso_file)} on ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  node                     = var.proxmox_node

  # Networking
  network_adapters {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
    vlan_tag = var.network_vlan
  }

  # Storage
  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    io_thread    = true
    storage_pool = var.disk_storage_pool
    type         = "scsi"
  }
  scsi_controller = "virtio-scsi-single"

  # Installation
  iso_file       = var.iso_file
  http_directory = "./"
  boot_wait      = "10s"
  boot_command   = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  unmount_iso    = true

  # Post-install
  cloud_init              = true
  cloud_init_storage_pool = var.cloudinit_storage_pool

  # VM
  vm_name  = trimsuffix(basename(var.iso_file), ".iso")
  cpu_type = var.cpu_type
  os       = "l26"
  memory   = var.memory
  cores    = var.cores
  sockets  = "1"
  machine  = var.machine_type

  # Note: this password is needed by packer to run the file provisioner, but
  # once that is done - the password will be set to random one by cloud init.
  # TODO At the moment the credentials below are able to be used but very unsafe to leave it like this
  ssh_password = "packer"
  ssh_username = "root"

  # Raise the timeout, when installation takes longer
  # TODO Move this to docs or README instead of comment
  # While testing on my machine it takes about 16-17 minutes each time to run
  ssh_timeout = "20m"
}

build {
  sources = ["source.proxmox-iso.debian"]

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "cloud.cfg"
  }
}
