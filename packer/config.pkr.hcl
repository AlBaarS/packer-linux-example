# -[ Packer settings ]---------------------------------------------------------
packer {
  required_plugins {
    vsphere = {
      version = "1.4.2"
      source  = "github.com/hashicorp/vsphere"
    }
    password = {
      version = "0.1.3"
      source  = "github.com/alexp-computematrix/password"
    }
  }
}