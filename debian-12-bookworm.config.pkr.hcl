packer {
  required_plugins {
    proxmox = {
      version = "1.1.3"
      #version = "1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }

    ansible = {
      version = "1.0.3"
      #version = "1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}