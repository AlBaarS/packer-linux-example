#!/bin/bash

# Define variables (in production, these would be Gitlab CI/CD environment variables)
export ISO_LOCATION="/media/distros/composer-api-7406badc-9b54-411a-bd77-4f1f8a867ca3-installer.iso"
export ISO_CHECKSUM="ad1698e918c80eaa8dc0abc135c52adf"
export USERNAME="user"
export PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNtLpFUpxw69p0hiHmV5HQ/zMhxcoBMGSzMMPa1DZH8 root@LPNLDAW0024"

# Execute the packer script
cd packer/
packer init config.pkr.hcl
packer build -var=iso_location=$ISO_LOCATION -var=iso_checksum=$ISO_CHECKSUM *.pkr.hcl
