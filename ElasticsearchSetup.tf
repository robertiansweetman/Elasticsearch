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