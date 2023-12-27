# Define your provider block for Oracle Cloud Infrastructure
 provider "oci" {
  tenancy_ocid          = "ocid1.tenancy.oc1..aaaaaaaajbell4743n7ejzfskd45apiqxue3wb5gr2ny4vayldrxwk2sb3uq"
  user_ocid             = "ocid1.user.oc1..aaaaaaaadvwp3dhwrfsc4cs2q7c5nzzgpzmx4kln5ryg5uuq4hg3jwicx6da"
  fingerprint           = "51:57:2f:32:b6:a4:7f:1c:34:45:7f:25:26:8f:19:c9"
  private_key_path      =  var.oci_private_key
  region                = "ap-tokyo-1"
}




# Define your compartment where the instance will be launched
resource "oci_identity_compartment" "hargun_compartment" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaak3vxdwgfg7f3prt6filp3govwpsptcaiszogipzaalvbewbc7uqq"
  name           = "ExampleCompartment"
  description    = "A description of your compartment"
}
# Create the DNS Zone
resource "oci_dns_zone" "private_dns_zone" {
  compartment_id = oci_identity_compartment.hargun_compartment.id
  name          = "vcn1.com"  # Replace with your desired DNS zone name
  zone_type     = "PRIMARY"
}

# Define a virtual network (VCN) and subnet for your instance
resource "oci_core_vcn" "vcn1" {
  compartment_id = oci_identity_compartment.hargun_compartment.id
  cidr_block     = "10.0.0.0/16"
  display_name  = "vcn1"

  # DNS settings
  dns_label = "vcn1" # Should match the DNS zone name
  #dns_resolution = "VCN_LOCAL"
}




resource "oci_core_subnet" "example_subnet" {
  compartment_id = oci_identity_compartment.hargun_compartment.id
  vcn_id         = oci_core_vcn.vcn1.id
  cidr_block     = "10.0.0.0/24"
  display_name   = "ExampleSubnet"
  dns_label      = "test"
  route_table_id = oci_core_route_table.example_route_table1.id
  availability_domain = "CtHA:AP-TOKYO-1-AD-1"  # Adjust to your desired availability domain
}


# Create an Internet Gateway
resource "oci_core_internet_gateway" "dns_vcn1" {
  compartment_id = oci_identity_compartment.hargun_compartment.id  # Replace with your compartment OCID
  vcn_id        = oci_core_vcn.vcn1.id
  display_name  = "dns"   # Replace with a name for the Internet Gateway
  enabled = true
}

# Create a Route Table
resource "oci_core_route_table" "example_route_table1" {
  compartment_id = oci_identity_compartment.hargun_compartment.id
  #manage_default_resource_id  = "ocid1.routetable.oc1.ap-tokyo-1.aaaaaaaaqecwj2ui4hkzaw7aqpgfdp4vt6iuo6ax5idjjaay6ox2ycv2abmq"
  vcn_id        = oci_core_vcn.vcn1.id
  display_name  = "My Route Table"

  route_rules {
    description = "Route to VCN2"
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.dns_vcn1.id
}
}
resource "oci_core_network_security_group" "example" {
  compartment_id = oci_identity_compartment.hargun_compartment.id
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "Example Security Group"
}

resource "oci_core_network_security_group_security_rule" "https" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "SSH"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports1" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports2" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 10250
      max = 10250
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports3" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 10251
      max = 10251
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports4" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 10252
      max = 10252
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports5" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 2379
      max = 2380
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports6" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 30000
      max = 32767
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports7" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 5432
      max = 5432
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports8" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 111
      max = 111
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports9" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "Allow All ingress"
  direction   = "INGRESS"
  protocol    = "all"
  stateless   = false
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "custom-ports10" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "Allow All egress"
  direction   = "EGRESS"
  protocol    = "all"
  stateless   = false
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "custom-ports11" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "UDP"
  direction   = "INGRESS"
  protocol    = 17
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
   udp_options {
    destination_port_range {
      min = 111
      max = 111
    }
  }

}

resource "oci_core_network_security_group_security_rule" "custom-ports12" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 2049
      max = 2049
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports13" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "UDP"
  direction   = "INGRESS"
  protocol    = 17
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
   udp_options {
    destination_port_range {
      min = 2049
      max = 2049
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports14" {
  network_security_group_id = oci_core_network_security_group.example.id

  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 20048
      max = 20048
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports15" {
  network_security_group_id = oci_core_network_security_group.example.id
  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 10256
      max = 10256
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports16" {
  network_security_group_id = oci_core_network_security_group.example.id
  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 1521
      max = 1521
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports17" {
  network_security_group_id = oci_core_network_security_group.example.id
  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 31815
      max = 31815
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports18" {
  network_security_group_id = oci_core_network_security_group.example.id
  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 1433
      max = 1433
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports19" {
  network_security_group_id = oci_core_network_security_group.example.id
  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 31858
      max = 31858
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports20" {
  network_security_group_id = oci_core_network_security_group.example.id
  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 25010
      max = 25010
    }
  }
}

resource "oci_core_network_security_group_security_rule" "custom-ports21" {
  network_security_group_id = oci_core_network_security_group.example.id
  description = "TCP"
  direction   = "INGRESS"
  protocol    = 6
  source_type        = "CIDR_BLOCK"
  source             = "0.0.0.0/0"
  destination_type   = "CIDR_BLOCK"
  destination        = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 32489
      max = 32489
    }
  }
}

# Define the instance
resource "oci_core_instance" "automation" {
  compartment_id         = oci_identity_compartment.hargun_compartment.id
  count                  = 3
  availability_domain    = "CtHA:AP-TOKYO-1-AD-1" # Adjust to your desired availability domain
  display_name = element(["Master", "Worker1", "Worker2"], count.index)
  #display_name           = "automation-${count.index + 1}"
  shape                  = "VM.Standard3.Flex"  # Adjust to your desired instance type
  # Specify the ShapeConfig properties for the flexible shape
  shape_config {
    ocpus    = "8"  # Number of OCPUs
    memory_in_gbs = "16"  # Amount of memory in GBs
  }
  subnet_id     = oci_core_subnet.example_subnet.id
  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaa7admg7j4l6ohm5yugngkkgmbw7fs35kew4nsy4guzctrirwcvsva"
 }


  create_vnic_details {
    assign_public_ip = var.public_ip == "RESERVED" ? var.assign_public_ip : true
    #vnic_id = oci_core_vnic.example_vnic.id
    subnet_id = oci_core_subnet.example_subnet.id
    nsg_ids   = [oci_core_network_security_group.example.id]

  }
   # Specify the SSH key OCID
  metadata = {
    ssh_authorized_keys = file("/root/.oci/my_public_key.pub")
    #user_data           = base64encode(file("/root/terr/install_kubernetes.sh"))
 }
}


# Output the instance's public IP address for convenience
output "instance_public_ip" {
  value = [for instance in oci_core_instance.automation : instance.public_ip]
}

                                  
