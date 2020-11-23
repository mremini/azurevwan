
//############################ Create Resource Group ##################

resource "azurerm_resource_group" "cloudteam_mremini_westeu" {
  name     = "cloudteam_mremini_westeu"
  location = "westeurope"
}




//############################ Create VNET and Subnets ##################

resource "azurerm_virtual_network" "mre_az_hub1_useast" {
  name                = "mre_az_westeu_hub1"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
  address_space       = [var.vnet1cidr]
  

  tags = {
    Project = "mre_lab"
    Role = "SecurityHub"
  }
}

resource "azurerm_subnet" "mre_az_westeu_hub1_pub" {
  name                 = "mre_az_westeu_hub1_pub"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_hub1_useast.name
  address_prefixes     = [var.vnet1_pub_subnetcidr]

}
resource "azurerm_subnet" "mre_az_westeu_hub1_priv" {
  name                 = "mre_az_westeu_hub1_priv"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_hub1_useast.name
  address_prefixes     = [var.vnet1_priv_subnetcidr]
  
}
resource "azurerm_subnet" "mre_az_westeu_hub1_ha" {
  name                 = "mre_az_westeu_hub1_ha"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_hub1_useast.name
  address_prefixes     = [var.vnet1_ha_subnetcidr]
  
}
resource "azurerm_subnet" "mre_az_westeu_hub1_mgmt" {
  name                 = "mre_az_westeu_hub1_mgmt"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_hub1_useast.name
  address_prefixes     = [var.vnet1_mgmt_subnetcidr]
  
}

//############################ Create RTB ##################
resource "azurerm_route_table" "mre_az_westeu_hub1_pub_RTB" {
  name                          = "mre_az_westeu_hub1_pub_RTB"
  location                      = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_westeu.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}
resource "azurerm_subnet_route_table_association" "mre_az_westeu_hub1_pubRTB_assoc" {
  subnet_id      = azurerm_subnet.mre_az_westeu_hub1_pub.id
  route_table_id = azurerm_route_table.mre_az_westeu_hub1_pub_RTB.id
}

resource "azurerm_route" "mre_az_westeu_hub1_pub_RTB_default" {
  name                = "defaultInternet"
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_westeu.name
  route_table_name              = azurerm_route_table.mre_az_westeu_hub1_pub_RTB.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

/////////////////
resource "azurerm_route_table" "mre_az_westeu_hub1_priv_RTB" {
  name                          = "mre_az_westeu_hub1_priv_RTB"
  location                      = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_westeu.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}
resource "azurerm_subnet_route_table_association" "mre_az_westeu_hub1_privRTB_assoc" {
  subnet_id      = azurerm_subnet.mre_az_westeu_hub1_priv.id
  route_table_id = azurerm_route_table.mre_az_westeu_hub1_priv_RTB.id
}


/////////////////
resource "azurerm_route_table" "mre_az_westeu_hub1_HA_RTB" {
  name                          = "mre_az_westeu_hub1_HA_RTB"
  location                      = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_westeu.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}
resource "azurerm_subnet_route_table_association" "mre_az_westeu_hub1_haRTB_assoc" {
  subnet_id      = azurerm_subnet.mre_az_westeu_hub1_ha.id
  route_table_id = azurerm_route_table.mre_az_westeu_hub1_HA_RTB.id
}


/////////////////
resource "azurerm_route_table" "mre_az_westeu_hub1_MGMT_RTB" {
  name                          = "mre_az_westeu_hub1_MGMT_RTB"
  location                      = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_westeu.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}
resource "azurerm_subnet_route_table_association" "mre_az_westeu_hub1_MGMTRTB_assoc" {
  subnet_id      = azurerm_subnet.mre_az_westeu_hub1_mgmt.id
  route_table_id = azurerm_route_table.mre_az_westeu_hub1_MGMT_RTB.id
}

resource "azurerm_route" "mre_az_westeu_hub1_mgmt_RTB_default" {
  name                = "defaultInternet"
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_westeu.name
  route_table_name              = azurerm_route_table.mre_az_westeu_hub1_MGMT_RTB.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}



//############################ Create NSG ##################

resource "azurerm_network_security_group" "fgt_nsg_pub" {
  name                = "westeu_hub1_fgt_pub_nsg"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
}
  
resource "azurerm_network_security_rule" "fgt_nsg_pub_rule_egress" {
  name                        = "AllOutbound"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_pub.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}
resource "azurerm_network_security_rule" "fgt_nsg_pub_rule_ingress_1" {
  name                        = "https"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_pub.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}

///////////////////

resource "azurerm_network_security_group" "fgt_nsg_priv" {
  name                = "westeu_hub1_fgt_priv_nsg"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
}

  resource "azurerm_network_security_rule" "fgt_nsg_priv_rule_egress" {
  name                        = "AllOutbound"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_priv.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}
resource "azurerm_network_security_rule" "fgt_nsg_priv_rule_ingress_1" {
  name                        = "TCP_ALL"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_priv.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  
} 
resource "azurerm_network_security_rule" "fgt_nsg_priv_rule_ingress_2" {
  name                        = "UDP_ALL"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_priv.name
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  
} 

/////////////////
resource "azurerm_network_security_group" "fgt_nsg_ha" {
  name                = "westeu_hub1_fgt_ha_nsg"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
}

  resource "azurerm_network_security_rule" "fgt_nsg_ha_rule_egress" {
  name                        = "AllOutbound"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_ha.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.vnet1cidr
  destination_address_prefix  = var.vnet1cidr
  
}
resource "azurerm_network_security_rule" "fgt_nsg_ha_rule_ingress_1" {
  name                        = "AllInbound"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_ha.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.vnet1cidr
  destination_address_prefix  = var.vnet1cidr
  
} 


/////////////////
resource "azurerm_network_security_group" "fgt_nsg_hmgmt" {
  name                = "westeu_hub1_fgt_mgmt_nsg"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
}

  resource "azurerm_network_security_rule" "fgt_nsg_hmgmt_rule_egress" {
  name                        = "AllOutbound"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_hmgmt.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}
resource "azurerm_network_security_rule" "fgt_nsg_hmgmt_rule_ingress_1" {
  name                        = "adminhttps"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_hmgmt.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "34443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}
resource "azurerm_network_security_rule" "fgt_nsg_hmgmt_rule_ingress_2" {
  name                        = "adminssh"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_security_group_name = azurerm_network_security_group.fgt_nsg_hmgmt.name
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3422"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}

//############################ PUBLIC IP  ############################

resource "azurerm_public_ip" "fgt1mgmtpip" {
  name                = "mre_az_westeu-fgt1-mgmtpip"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "fgt2mgmtpip" {
  name                = "mre_az_westeu-fgt2-mgmtpip"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "clusterpip" {
  name                = "mre_az_westeu-fgt-cl-pip"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


//############################ FGT1 NIC  ############################
resource "azurerm_network_interface" "fgt1_pub_nic" {
  name                      = "mre_az_westeu-fgt1-port1"
  location                  = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name       = azurerm_resource_group.cloudteam_mremini_westeu.name
  enable_ip_forwarding      = true
  enable_accelerated_networking   = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_westeu_hub1_pub.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet1_fgt1_public_ip
    public_ip_address_id                    = azurerm_public_ip.clusterpip.id
  }
}

resource "azurerm_network_interface_security_group_association" "fgt1_pub_nic-nsg" {
  network_interface_id      = azurerm_network_interface.fgt1_pub_nic.id
  network_security_group_id = azurerm_network_security_group.fgt_nsg_pub.id
}

/////////////////////

resource "azurerm_network_interface" "fgt1_priv_nic" {
  name                      = "mre_az_westeu-fgt1-port2"
  location                  = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name       = azurerm_resource_group.cloudteam_mremini_westeu.name
  enable_ip_forwarding      = true
  enable_accelerated_networking   = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_westeu_hub1_priv.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet1_fgt1_private_ip
  }
}

resource "azurerm_network_interface_security_group_association" "fgt1_priv_nic-nsg" {
  network_interface_id      = azurerm_network_interface.fgt1_priv_nic.id
  network_security_group_id = azurerm_network_security_group.fgt_nsg_priv.id
}
/////////////////////

resource "azurerm_network_interface" "fgt1_ha_nic" {
  name                      = "mre_az_westeu-fgt1-port3"
  location                  = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name       = azurerm_resource_group.cloudteam_mremini_westeu.name
  enable_ip_forwarding      = false
  enable_accelerated_networking   = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_westeu_hub1_ha.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet1_fgt1_ha_ip
  }
}
resource "azurerm_network_interface_security_group_association" "fgt1_ha_nic-nsg" {
  network_interface_id      = azurerm_network_interface.fgt1_ha_nic.id
  network_security_group_id = azurerm_network_security_group.fgt_nsg_ha.id
}
/////////////////////

resource "azurerm_network_interface" "fgt1_mgmt_nic" {
  name                      = "mre_az_westeu-fgt1-port4"
  location                  = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name       = azurerm_resource_group.cloudteam_mremini_westeu.name
  enable_ip_forwarding      = false
  enable_accelerated_networking   = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_westeu_hub1_mgmt.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet1_fgt1_mgmt_ip
    public_ip_address_id                    = azurerm_public_ip.fgt1mgmtpip.id
  }
}

resource "azurerm_network_interface_security_group_association" "fgt1_mgmt_nic-nsg" {
  network_interface_id      = azurerm_network_interface.fgt1_mgmt_nic.id
  network_security_group_id = azurerm_network_security_group.fgt_nsg_hmgmt.id
}

//############################ FGT2 NIC  ############################

resource "azurerm_network_interface" "fgt2_pub_nic" {
  name                      = "mre_az_westeu-fgt2-port1"
  location                  = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name       = azurerm_resource_group.cloudteam_mremini_westeu.name
  enable_ip_forwarding      = true
  enable_accelerated_networking   = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_westeu_hub1_pub.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet1_fgt2_public_ip
  }
}

resource "azurerm_network_interface_security_group_association" "fgt2_pub_nic-nsg" {
  network_interface_id      = azurerm_network_interface.fgt2_pub_nic.id
  network_security_group_id = azurerm_network_security_group.fgt_nsg_pub.id
}

//////////////

resource "azurerm_network_interface" "fgt2_priv_nic" {
  name                      = "mre_az_westeu-fgt2-port2"
  location                  = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name       = azurerm_resource_group.cloudteam_mremini_westeu.name
  enable_ip_forwarding      = true
  enable_accelerated_networking   = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_westeu_hub1_priv.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet1_fgt2_private_ip
  }
}

resource "azurerm_network_interface_security_group_association" "fgt2_priv_nic-nsg" {
  network_interface_id      = azurerm_network_interface.fgt2_priv_nic.id
  network_security_group_id = azurerm_network_security_group.fgt_nsg_priv.id
}

////////////

resource "azurerm_network_interface" "fgt2_ha_nic" {
  name                      = "mre_az_westeu-fgt2-port3"
  location                  = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name       = azurerm_resource_group.cloudteam_mremini_westeu.name
  enable_ip_forwarding      = false
  enable_accelerated_networking   = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_westeu_hub1_ha.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet1_fgt2_ha_ip
  }
}

resource "azurerm_network_interface_security_group_association" "fgt2_ha_nic-nsg" {
  network_interface_id      = azurerm_network_interface.fgt2_ha_nic.id
  network_security_group_id = azurerm_network_security_group.fgt_nsg_ha.id
}

////////////

resource "azurerm_network_interface" "fgt2_mgmt_nic" {
  name                      = "mre_az_westeu-fgt2-port4"
  location                  = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name       = azurerm_resource_group.cloudteam_mremini_westeu.name
  enable_ip_forwarding      = false
  enable_accelerated_networking   = true

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_westeu_hub1_mgmt.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet1_fgt2_mgmt_ip
    public_ip_address_id                    = azurerm_public_ip.fgt2mgmtpip.id
  }
}

resource "azurerm_network_interface_security_group_association" "fgt2_mgmt_nic-nsg" {
  network_interface_id      = azurerm_network_interface.fgt2_mgmt_nic.id
  network_security_group_id = azurerm_network_security_group.fgt_nsg_hmgmt.id
}

//############################ FGT1 VM  ############################

data "template_file" "fgt1_customdata" {
  template = file ("./assets/fgt-userdata.tpl")
  vars = {
    fgt_id              = "westeu_hub1_ap_fgt1"
    fgt_license_file    = var.fgt1lic
    fgt_username        = var.username
    fgt_config_ha       = var.vnet1fgtha
    fgt_ssh_public_key  = ""

    Port1IP             = var.vnet1_fgt1_public_ip
    Port2IP             = var.vnet1_fgt1_private_ip
    Port3IP             = var.vnet1_fgt1_ha_ip

    public_subnet_mask  = cidrnetmask(var.vnet1_pub_subnetcidr)
    private_subnet_mask = cidrnetmask(var.vnet1_priv_subnetcidr)
    ha_subnet_mask      = cidrnetmask((var.vnet1_ha_subnetcidr))

    fgt_external_gw     = cidrhost(var.vnet1_pub_subnetcidr, 1)
    fgt_internal_gw     = cidrhost(var.vnet1_priv_subnetcidr, 1)
    fgt_mgmt_gw         = cidrhost(var.vnet1_mgmt_subnetcidr, 1)

  
    fgt_ha_peerip       = var.vnet1_fgt2_ha_ip
    fgt_ha_priority     = "100"
    vnet_network        = var.vnet1cidr
  }
}

resource "azurerm_virtual_machine" "fgt1" {
  name                         = "westeu-hub1-ap-fgt1"
  location                     = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name          = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_interface_ids        = [azurerm_network_interface.fgt1_pub_nic.id, azurerm_network_interface.fgt1_priv_nic.id, azurerm_network_interface.fgt1_ha_nic.id, azurerm_network_interface.fgt1_mgmt_nic.id]
  primary_network_interface_id = azurerm_network_interface.fgt1_pub_nic.id
  vm_size                      = var.fgt_vmsize

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = var.FGT_IMAGE_SKU
    version   = var.FGT_VERSION
  }

  plan {
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
    name      = var.FGT_IMAGE_SKU
  }

  storage_os_disk {
    name              = "westeu_hub1_ap_fgt1_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name = "westeu_hub1_ap_fgt1_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option = "Empty"
    lun = 0
    disk_size_gb = "10"
  }


  os_profile {
    computer_name  = "westeu-hub1-ap-fgt1"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.fgt1_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  zones = [1]
    
  boot_diagnostics {
    enabled     = true
    storage_uri = "https://mrefgtserialconsole.blob.core.windows.net/"
  }

    tags = {
    Project = "mre_lab"
    Role = "FTNT"
  }

}


//############################ FGT2 VM  ############################

data "template_file" "fgt2_customdata" {
  template = file ("./assets/fgt-userdata.tpl")
  vars = {
    fgt_id              = "westeu_hub1_ap_fgt2"
    fgt_license_file    = var.fgt2lic
    fgt_username        = var.username
    fgt_config_ha       = var.vnet1fgtha
    fgt_ssh_public_key  = ""

    Port1IP             = var.vnet1_fgt2_public_ip
    Port2IP             = var.vnet1_fgt2_private_ip
    Port3IP             = var.vnet1_fgt2_ha_ip

    public_subnet_mask  = cidrnetmask(var.vnet1_pub_subnetcidr)
    private_subnet_mask = cidrnetmask(var.vnet1_priv_subnetcidr)
    ha_subnet_mask      = cidrnetmask((var.vnet1_ha_subnetcidr))

    fgt_external_gw     = cidrhost(var.vnet1_pub_subnetcidr, 1)
    fgt_internal_gw     = cidrhost(var.vnet1_priv_subnetcidr, 1)
    fgt_mgmt_gw         = cidrhost(var.vnet1_mgmt_subnetcidr, 1)

  
    fgt_ha_peerip       = var.vnet1_fgt1_ha_ip
    fgt_ha_priority     = "50"
    vnet_network        = var.vnet1cidr
  }
}

resource "azurerm_virtual_machine" "fgt2" {
  name                         = "westeu-hub1-ap-fgt2"
  location                     = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name          = azurerm_resource_group.cloudteam_mremini_westeu.name
  network_interface_ids        = [azurerm_network_interface.fgt2_pub_nic.id, azurerm_network_interface.fgt2_priv_nic.id, azurerm_network_interface.fgt2_ha_nic.id, azurerm_network_interface.fgt2_mgmt_nic.id]
  primary_network_interface_id = azurerm_network_interface.fgt2_pub_nic.id
  vm_size                      = var.fgt_vmsize

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = var.FGT_IMAGE_SKU
    version   = var.FGT_VERSION
  }

  plan {
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
    name      = var.FGT_IMAGE_SKU
  }

  storage_os_disk {
    name              = "westeu_hub1_ap_fgt2_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name = "westeu_hub1_ap_fgt2_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option = "Empty"
    lun = 0
    disk_size_gb = "10"
  }


  os_profile {
    computer_name  = "westeu-hub1-ap-fgt2"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.fgt2_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "https://mrefgtserialconsole.blob.core.windows.net/"
  }


  zones = [2]

    tags = {
    Project = "mre_lab"
    Role = "FTNT"
  }

}