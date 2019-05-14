# TODO: figure out how to 'install' things on it using Ansible...
# TODO: can we use Ansible to manage things rather than Terraform ?

module "global_variables" {
  source = "./Modules/Shared/global_variables"
}

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

data "vsphere_datastore" "datastore" {
  name      = "Non-SSD"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

# get template name from global_variables.tf
data "vsphere_virtual_machine" "template" {
  name = "${module.global_variables.template_name}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name = "qa-elasticsearch"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  num_cpus = 1
  memory = 2048
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  } 

  disk {
    label = "disk0"
    size  = 80
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  # TODO: Take a proper look at 'clone' params and UNDERSTAND THEM
  # FIXME: Need to add a hostname, which REQUIRES a domain parameter
  # customize {
  #   linux_options {
  #    host_name = "qa-elastic"
  #    domain    = "test.internal" <== don't think we are on the domain!
  #   }

  #   network_interface {
  #    ipv4_address = "10.0.0.10" #172.16.200.0
  #    ipv4_netmask = 24
  #   }

  #   ipv4_gateway = "10.0.0.1" #172.16.200.1
  # }  
  
}