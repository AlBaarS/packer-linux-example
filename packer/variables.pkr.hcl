# -[ ISO template ]------------------------------------------------------------
variable "iso_url" {
    type    = string
    default = "http://mirror.netone.nl/centos/10-stream/BaseOS/x86_64/iso/CentOS-Stream-10-latest-x86_64-dvd1.iso"
}

variable "iso_checksum" {
    type    = string
    default = env("checksum")
}

# -[ User settings ]-----------------------------------------------------------
variable "ssh_username" {
    type    = string
    default = env("SSH_USER")
}

data "password" "random_password" {
  length    = 32
}

# -[ Machine settings ]--------------------------------------------------------
variable "machine_name" {
  type        = string
  default     = "centos10S"
  description = "Will be taken from an input/environment variable in the future"
}

variable "boot_wait" {
  type        = string
  default     = "15s"
}

variable "memsize" {
  type        = string
  default     = "2048"
}

variable "numvcpus" {
  type        = string
  default     = "2"
}

variable "disk_size" {
  type        = string
  default     = "40960"
  description = "The amount of storage allocated to the VM (in MB)"
}

variable "disk_controller_type" {
  type        = list(string)
  default     = ["pvscsi"]
  description = "The type of storage controller to use for virtual machine disks."
}

variable "network_card" {
  type        = string
  default     = "vmxnet3"
  description = "The type of network card to use for the virtual machine."
}

variable "insecure_connection" {
  type        = bool
  default     = true
  description = "Set to true to allow insecure connections to the vCenter instance."
}

# -[ Vcenter/Vsphere connection ]----------------------------------------------
# It needs a connection to temporarily make a VM on which the actions are
# performed, after which the VM is packaged into an OVF image

variable "vcenter_username" {
    type      = string
    default   = env("VSPHERE_USER")
}

variable "vcenter_password" {
    type      = string
    default   = env("VSPHERE_PASSWORD")
}

variable "vcenter_server" {
  type        = string
  default     = "photon-machine.sogyo.nl"
  description = "The vCenter instance used for managing the ESX host."
}

variable "host" {
  type        = string
  default     = "vs1.sogyo.nl"
  description = "The ESX host where the virtual machine will be built."
}

variable "datacenter" {
  type        = string
  default     = "Boerderij"
  description = "The name of the datacenter itself"
}

variable "datastore" {
  type        = string
  default     = "HPE RAID 10"
  description = "The ESXi datastore where the ISO and virtual machine will be stored."
}

variable "resource_pool" {
  type        = string
  default     = "Company"
  description = "The resource pool (kind of like a directory?) where the VMs will be temporarily hosted"
}

variable "vm_folder" {
  type        = string
  default     = "Templates"
  description = "The directory where the VM will be tempirarily hosted and the template stored"
}

variable "vm_name_prefix" {
  type    = string
  # default = "RHEL9"
  default = "CentOS10"
}

variable "guest_os_type" {
    type    = string
    default = "centos8_64Guest"
}

variable "network_name" {
  type        = string
  default     = "VM Network"
  description = "The network name to attach the virtual machine to."
}

# -[ Template configuration ]--------------------------------------------------

variable "template_name" {
  type        = string
  default     = "CentOS10-Company-vs1"
  description = "The name to be given to the stored OVF template"
}

variable "template_description" {
  type        = string
  default     = "Hardened, golden image of RedHat's CentOS10Stream"
  description = "The description to be given to the template"
}

variable "template_folder" {
  type        = string
  default     = "Templates"
  description = "The directory where the template will be saved"
}

variable "ovf_creation" {
  type        = bool
  default     = true
  description = "Determines whether the outputted format will be in the OVF format (which does impose some restrictions)"
}

variable "machine_destroy" {
  type        = bool
  default     = true
  description = "Determines whether the machine created for the template should be destroyed"
}

# -[ Gitlab files/variables ]--------------------------------------------------

variable "ci_project_dir" {
  type        = string
  default     = env("CI_PROJECT_DIR")
}

variable "ssh_pubkey" {
  type        = string
  default     = "company-key.pub"
}

variable "ssh_privkey" {
  type        = string
  default     = "company-key"
}

# -[ Local variables ]---------------------------------------------------------
# locals {
#   # iso_path  = "[${var.datastore}] ${var.datastore_path}/alpine-standard-${var.alpine_version}-x86_64.iso"
#   timestamp = regex_replace(timestamp(), "[- TZ:]", "")
# }

locals {
  kickstart = templatefile(
      "${path.root}/config_templates/kickstart_file.pkrtpl", {
        username              = var.ssh_username
        password              = data.password.random_password.crypt
        pubkey                = file("${var.ci_project_dir}/${var.ssh_pubkey}")
        machine_name          = var.machine_name
      }
    )
  issue-motd = templatefile(
    "${path.root}/config_templates/issue-motd.pkrtpl", {
      machine_name            = var.machine_name
    }
  )
  execution_dir = "/home/${var.ssh_username}/"
}