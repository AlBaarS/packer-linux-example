# Packer Linux Template Provider

## Description

This gitlab repository creates a hardened CentOS image (version 10 Stream) and stores it on a vSphere cluster.

## Mechanics

Packer creates a temporary virtual machine from an ISO file and configures that with the given parameters and a random password. After the process is finished, it is exported as a template in the folder where Packer creates the temporary VM for configuration.

## vSphere Prerequisites 

A vSphere account must be provided with sufficient rights to upload files, create virtual machines, and save templates. The authentication for vSphere is configured through Gitlab CI/CD environment variables `VSHERE_USER` and `VSPHERE_PASSWORD`.

## Further configuration

A username for the desired user must be provided through the `SSH_USER` CI/CD environment variable. Furthermore, it assumes that the private key that corresponds to the public key in the repository is available under the `DEPLOYMENT_SSH_KEY` variable.

## Using the template

The template is meant to be used with Terraform, and can be cloned from its location. You must use the correct key to connect with the VM. When connecting manually, specify the key file with the `-i path/to/key` flag, and ensure it is used with `-o "IdentitiesOnly=yes"`.
