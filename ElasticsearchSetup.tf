# TODO: add reference to global variables

# VMWare 'control' script
# TODO: Add these later
# Prepare global variables

# module "global_variables" {
#  source="./Modules/Shared/global_variables"
# }

module "credentials" {
  source = "./Modules/Shared/credentials"
}

provider "vsphere" {
  user           = "${module.credentials.vsphere_user}"
  password       = "${module.credentials.vsphere_password}"
  vsphere_server = "${module.credentials.vsphere_server}"

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "${module.credentials.datacenter_name}"
}

output "datacenter_id" {
  value = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_network" "network" {
  name          = "${module.credentials.network_name}" # Default is "VM Network"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${module.credentials.resource_pool_name}" # ESXi can leave this blank
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

# TODO: might have to look in a folder for sthg
# TODO: create the first Debian machine on here
# TODO: figure out how to 'install' things on it using Ansible...
# TODO: can we use Ansible to manage things rather than Terraform since it always seems to seek to destroy everything and start over... 
