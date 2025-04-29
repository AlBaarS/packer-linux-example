# -[ Build source ]------------------------------------------------------------
source "vsphere-iso" "centos10" {
  # Vcenter configuration
  username                    = var.vcenter_username
  password                    = var.vcenter_password
  vcenter_server              = var.vcenter_server
  datacenter                  = var.datacenter
  datastore                   = var.datastore
  host                        = var.host
  insecure_connection         = var.insecure_connection
  # vm_name                     = "${var.vm_name_prefix}-${local.timestamp}"
  vm_name                     = "${var.vm_name_prefix}-hardened-image"
  resource_pool               = var.resource_pool
  folder                      = var.vm_folder
  iso_url                     = var.iso_url
  iso_checksum                = var.iso_checksum
  convert_to_template         = true

  # I need more permissions to execute this
  # see https://blogs.vmware.com/vsphere/2020/01/creating-and-using-content-library.html
  # content_library_destination {
  #   name          = var.template_name
  #   description   = var.template_description
  #   folder        = var.template_folder
  #   host          = var.host
  #   resource_pool = var.resource_pool
  #   datastore     = var.datastore
  #   ovf           = var.ovf_creation
  #   destroy       = var.machine_destroy
  # }

  # Communicator settings
  communicator                = "ssh"
  ssh_username                = var.ssh_username
  ssh_private_key_file        = "${var.ci_project_dir}/${var.ssh_privkey}"

  # Image configuration
  guest_os_type               = var.guest_os_type
  CPUs                        = var.numvcpus
  RAM                         = var.memsize
  RAM_reserve_all             = true
  network_adapters {
    network_card = var.network_card
    network      = var.network_name
  }
  storage {
    disk_size                 = var.disk_size
    disk_thin_provisioned     = true
  }
  disk_controller_type = var.disk_controller_type

  # Boot configuration
  ##cd_content is used to load the user data onto a virtual CDROM
  cd_content = {
    "/ks.cfg"  = local.kickstart
  }
  ## The boot command then loads the virtual CDROM into the boot process
  boot_command                = ["<up>e", "<down><down><end>", " text inst.ks=cdrom", "<enter><wait><leftCtrlOn>x<leftCtrlOff>"]
  boot_wait                   = var.boot_wait
  shutdown_command            = "sudo /usr/sbin/shutdown -h now"
}

build {
  sources = ["source.vsphere-iso.centos10"]

  # Get necessary config files onto the remote machibe
  provisioner "file" {
    source      = "config_files/"
    destination = "/tmp/"
  }

  ## Uses the template, fills in the variables, and parses it to /tmp/issue-motd
  provisioner "file" {
    content     = local.issue-motd
    destination = "/tmp/issue-motd"
  }

  # Move the config files to the correct position
  provisioner "shell" {
    inline      = [
      "sudo mv /tmp/CIS.conf /etc/modprobe.d/CIS.conf",
      "sudo cp -u /tmp/issue-motd /etc/motd",
      "sudo mv /tmp/issue-motd /etc/issue.net",
      "sudo mv /tmp/coredump.conf /etc/systemd/coredump.conf",
      "sudo mv /tmp/journald.conf /etc/systemd/journald.conf",
      "sudo mv /tmp/00-media-automount /etc/dconf/db/local.d/00-media-automount"
    ]
  }

  # Set configuration permissions & reload with new settings
  provisioner "shell" {
    inline      = [
      "sudo chown --recursive root:root /etc/*",
      "sudo chown chrony:chrony /etc/chrony.conf",
      "sudo chmod 600 /etc/ssh/sshd_config",
      "sudo dconf update"
    ]
  }

  # Get the scripts onto the remote machine
  provisioner "file" {
    source      = "hardening_scripts/"
    destination = local.execution_dir
  }

  # Execute the scripts on the remote host and remove them
  provisioner "shell" {
    inline      = [
      "cd ${local.execution_dir}",
      "sudo bash change_cron_permissions.sh",
      "sudo bash configure_audit_rules.sh",
      "sudo bash configure_chrony.sh",
      "sudo bash configure_faillock.sh",
      "sudo bash configure_kernel.sh",
      "sudo bash configure_network_access.sh",
      "sudo bash configure_password_requirements.sh",
      "sudo bash configure_rsyslog.sh",
      "sudo bash augenrules_load.sh",
      "rm *.sh"
    ]
  }
}