

//############################ Create Resource Group ##################

resource "azurerm_resource_group" "cloudteam_mremini_eastus_usse" {
  provider  = azurerm.usse
  name     = "cloudteam_mremini_eastus_usse"
  location = "eastus"
}


//############################ Create VNET and subnets ##################

resource "azurerm_virtual_network" "mre_az_eastus_hub1_usse" {
  provider  = azurerm.usse
  name                = "mre_az_eastus_hub1_usse"
  location            = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  address_space       = [var.vnet2cidr]
  

  tags = {
    Project = "mre_lab"
    Role = "SecurityHub"
  }
}

resource "azurerm_subnet" "mre_az_useast_hub1_usse_pub" {
  provider             = azurerm.usse
  name                 = "mre_az_useast_hub1_usse_pub"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  virtual_network_name = azurerm_virtual_network.mre_az_eastus_hub1_usse.name
  address_prefixes     = [var.vnet2_pub_subnetcidr]

}
resource "azurerm_subnet" "mre_az_useast_hub1_usse_priv" {
  provider             = azurerm.usse
  name                 = "mre_az_useast_hub1_usse_priv"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  virtual_network_name = azurerm_virtual_network.mre_az_eastus_hub1_usse.name
  address_prefixes     = [var.vnet2_priv_subnetcidr]
  
}

resource "azurerm_subnet" "mre_az_useast_hub1_usse_backend1" {
  provider             = azurerm.usse
  name                 = "mre_az_useast_hub1_usse_backend1"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  virtual_network_name = azurerm_virtual_network.mre_az_eastus_hub1_usse.name
  address_prefixes     = [var.vnet2_backend1_subnetcidr]
  
}
resource "azurerm_subnet" "mre_az_useast_hub1_usse_backend2" {
  provider             = azurerm.usse
  name                 = "mre_az_useast_hub1_usse_backend2"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  virtual_network_name = azurerm_virtual_network.mre_az_eastus_hub1_usse.name
  address_prefixes     = [var.vnet2_backend2_subnetcidr]
  
}

//############################ Create RTB ##################
resource "azurerm_route_table" "mre_az_useast_hub1_usse_pub-RTB" {
  provider                      = azurerm.usse 
  name                          = "mre_az_useast_hub1_usse_pub"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}
resource "azurerm_subnet_route_table_association" "mre_az_useast_hub1_usse_pub_assoc" {
  provider                      = azurerm.usse 
  subnet_id                     = azurerm_subnet.mre_az_useast_hub1_usse_pub.id
  route_table_id                = azurerm_route_table.mre_az_useast_hub1_usse_pub-RTB.id
}

resource "azurerm_route" "mre_az_useast_hub1_usse_pub_RTB_default" {
  provider             = azurerm.usse
    name                          = "defaultInternet"
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  route_table_name              = azurerm_route_table.mre_az_useast_hub1_usse_pub-RTB.name
  address_prefix                = "0.0.0.0/0"
  next_hop_type                 = "Internet"
}

/////////////////

resource "azurerm_route_table" "mre_az_useast_hub1_usse_priv-RTB" {
  provider                      = azurerm.usse
  name                          = "mre_az_useast_hub1_usse_priv-RTB"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}
resource "azurerm_subnet_route_table_association" "mre_az_useast_hub1_usse_priv-RTB_assoc" {
  provider                      = azurerm.usse
  subnet_id                     = azurerm_subnet.mre_az_useast_hub1_usse_priv.id
  route_table_id                = azurerm_route_table.mre_az_useast_hub1_usse_priv-RTB.id
}


/////////////////
resource "azurerm_route_table" "mre_az_useast_hub1_usse_backend_RTB" {
  provider                      = azurerm.usse
  name                          = "mre_az_useast_hub1_usse_backend_RTB"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}
resource "azurerm_subnet_route_table_association" "mre_az_useast_hub1_usse_backend1_RTB_assoc" {
  provider                      = azurerm.usse
  subnet_id                     = azurerm_subnet.mre_az_useast_hub1_usse_backend1.id
  route_table_id                = azurerm_route_table.mre_az_useast_hub1_usse_backend_RTB.id
}
resource "azurerm_subnet_route_table_association" "mre_az_useast_hub1_usse_backend2_RTB_assoc" {
  provider                      = azurerm.usse
  subnet_id                     = azurerm_subnet.mre_az_useast_hub1_usse_backend2.id
  route_table_id                = azurerm_route_table.mre_az_useast_hub1_usse_backend_RTB.id
}


//############################ Create NSG ##################

resource "azurerm_network_security_group" "useast_hub1_usse_fgt_pub_nsg" {
  provider                      = azurerm.usse
  name                          = "useast_hub1_usse_fgt_pub_nsg"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
}
  
resource "azurerm_network_security_rule" "useast_hub1_usse_fgt_pub_nsg_rule_egress" {
  provider                      = azurerm.usse
  name                        = "AllOutbound"
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_security_group_name =   azurerm_network_security_group.useast_hub1_usse_fgt_pub_nsg.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}
resource "azurerm_network_security_rule" "useast_hub1_usse_fgt_pub_nsg_rule_ingress_1" {
  provider                      = azurerm.usse
  name                        = "https"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_security_group_name = azurerm_network_security_group.useast_hub1_usse_fgt_pub_nsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}
resource "azurerm_network_security_rule" "useast_hub1_usse_fgt_pub_nsg_rule_ingress_2" {
  provider                      = azurerm.usse
  name                        = "udp500"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_security_group_name = azurerm_network_security_group.useast_hub1_usse_fgt_pub_nsg.name
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "500"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}
resource "azurerm_network_security_rule" "useast_hub1_usse_fgt_pub_nsg_rule_ingress_3" {
  provider                      = azurerm.usse
  name                        = "udp4500"
  resource_group_name         = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_security_group_name = azurerm_network_security_group.useast_hub1_usse_fgt_pub_nsg.name
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "4500"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}

///////////////////

resource "azurerm_network_security_group" "useast_hub1_usse_fgt_priv_nsg" {
  provider                      = azurerm.usse
  name                = "useast_hub1_usse_fgt_priv_nsg"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
}

  resource "azurerm_network_security_rule" "useast_hub1_usse_fgt_priv_nsg_rule_egress" {
    provider                      = azurerm.usse
  name                        = "AllOutbound"
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_security_group_name = azurerm_network_security_group.useast_hub1_usse_fgt_priv_nsg.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  
}
resource "azurerm_network_security_rule" "useast_hub1_usse_fgt_priv_nsg_rule_ingress_1" {
  provider                      = azurerm.usse
  name                        = "TCP_ALL"
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_security_group_name = azurerm_network_security_group.useast_hub1_usse_fgt_priv_nsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  
} 
resource "azurerm_network_security_rule" "useast_hub1_usse_fgt_priv_nsg_rule_ingress_2" {
  provider                      = azurerm.usse  
  name                        = "UDP_ALL"
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_security_group_name = azurerm_network_security_group.useast_hub1_usse_fgt_priv_nsg.name
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  
} 



//############################ PUBLIC IP  ############################




//############################ FGT1 NIC  ############################
resource "azurerm_network_interface" "useast_hub1_usse-fgt1_pub_nic" {
  provider                      = azurerm.usse
  name                          = "mre_az_useast_hub1_usse-fgt1-port1"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  enable_ip_forwarding          = true
  enable_accelerated_networking   = false

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_useast_hub1_usse_pub.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet2_fgt1_public_ip
  }
}

resource "azurerm_network_interface_security_group_association" "useast_hub1_usse-fgt1_pub_nic-nsg" {
  provider                      = azurerm.usse
  network_interface_id      = azurerm_network_interface.useast_hub1_usse-fgt1_pub_nic.id
  network_security_group_id = azurerm_network_security_group.useast_hub1_usse_fgt_pub_nsg.id
}

/////////////////////

resource "azurerm_network_interface" "useast_hub1_usse-fgt1_priv_nic" {

  provider                      = azurerm.usse
  name                          = "mre_az_useast_hub1_usse-fgt1-port2"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  enable_ip_forwarding          = true
  enable_accelerated_networking   = false

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_useast_hub1_usse_priv.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet2_fgt1_private_ip
  }
}

resource "azurerm_network_interface_security_group_association" "useast_hub1_usse-fgt1_priv_nic-nsg" {
  provider                      = azurerm.usse
  network_interface_id      = azurerm_network_interface.useast_hub1_usse-fgt1_priv_nic.id
  network_security_group_id = azurerm_network_security_group.useast_hub1_usse_fgt_priv_nsg.id
}

//############################ FGT2 NIC  ############################

resource "azurerm_network_interface" "useast_hub1_usse-fgt2_pub_nic" {
  provider                      = azurerm.usse
  name                          = "mre_az_useast_hub1_usse-fgt2-port1"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  enable_ip_forwarding          = true
  enable_accelerated_networking   = false

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_useast_hub1_usse_pub.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet2_fgt2_public_ip
  }
}

resource "azurerm_network_interface_security_group_association" "useast_hub1_usse-fgt2_pub_nic-nsg" {
  provider                      = azurerm.usse
  network_interface_id      = azurerm_network_interface.useast_hub1_usse-fgt2_pub_nic.id
  network_security_group_id = azurerm_network_security_group.useast_hub1_usse_fgt_pub_nsg.id
}

/////////////////////

resource "azurerm_network_interface" "useast_hub1_usse-fgt2_priv_nic" {

  provider                      = azurerm.usse
  name                          = "mre_az_useast_hub1_usse-fgt2-port2"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  enable_ip_forwarding          = true
  enable_accelerated_networking   = false

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = azurerm_subnet.mre_az_useast_hub1_usse_priv.id
    private_ip_address_allocation           = "static"
    private_ip_address                      = var.vnet2_fgt2_private_ip
  }
}

resource "azurerm_network_interface_security_group_association" "useast_hub1_usse-fgt2_priv_nic-nsg" {
provider                      = azurerm.usse
  network_interface_id      = azurerm_network_interface.useast_hub1_usse-fgt2_priv_nic.id
  network_security_group_id = azurerm_network_security_group.useast_hub1_usse_fgt_priv_nsg.id
}




//############################ FGT1 VM  ############################

data "template_file" "useast_usse_hub1_fgt1_customdata" {
  template = file ("./assets/fgt-aa-userdata.tpl")
  vars = {
    fgt_id              = "useast_usse_hub1_fgt1"
    fgt_license_file    = var.eastussefgt1lic
    fgt_username        = var.username
    fgt_config_ha       = false
    fgt_config_autoscale = true
    fgt_ssh_public_key  = ""

    Port1IP             = var.vnet2_fgt1_public_ip
    Port2IP             = var.vnet2_fgt1_private_ip

    public_subnet_mask  = cidrnetmask(var.vnet2_pub_subnetcidr)
    private_subnet_mask = cidrnetmask(var.vnet2_priv_subnetcidr)

    fgt_external_gw     = cidrhost(var.vnet2_pub_subnetcidr, 1)
    fgt_internal_gw     = cidrhost(var.vnet2_priv_subnetcidr, 1)
    vnet_network        = var.vnet2cidr

  
    role              = "master"
    sync-port         = "port2"
    psk               = var.password
    
  }
}

resource "azurerm_virtual_machine" "useast_usse_hub1_fgt1" {
  provider                      = azurerm.usse
  name                         = "useast_usse_hub1_fgt1"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_interface_ids        = [azurerm_network_interface.useast_hub1_usse-fgt1_pub_nic.id, azurerm_network_interface.useast_hub1_usse-fgt1_priv_nic.id]
  primary_network_interface_id = azurerm_network_interface.useast_hub1_usse-fgt1_pub_nic.id
  vm_size                      = var.fgtvnet2_vmsize

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
    name              = "useast_usse_hub1_fgt1_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name = "useast_usse_hub1_fgt1_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option = "Empty"
    lun = 0
    disk_size_gb = "10"
  }

  os_profile {
    computer_name  = "useast-usse-hub1-fgt1"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.useast_usse_hub1_fgt1_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  zones = [1]
    
  boot_diagnostics {
    enabled     = true
    storage_uri = "https://mreminiserial.blob.core.windows.net/"
  }

    tags = {
    Project = "mre_lab"
    Role = "FTNT"
  }

}


//############################ FGT2 VM  ############################

data "template_file" "useast_usse_hub1_fgt2_customdata" {
  template = file ("./assets/fgt-aa-userdata.tpl")
  vars = {
    fgt_id              = "useast_usse_hub1_fgt2"
    fgt_license_file    = var.eastussefgt2lic
    fgt_username        = var.username
    fgt_config_ha       = false
    fgt_config_autoscale = true
    fgt_ssh_public_key  = ""

    Port1IP             = var.vnet2_fgt2_public_ip
    Port2IP             = var.vnet2_fgt2_private_ip

    public_subnet_mask  = cidrnetmask(var.vnet2_pub_subnetcidr)
    private_subnet_mask = cidrnetmask(var.vnet2_priv_subnetcidr)

    fgt_external_gw     = cidrhost(var.vnet2_pub_subnetcidr, 1)
    fgt_internal_gw     = cidrhost(var.vnet2_priv_subnetcidr, 1)
    vnet_network        = var.vnet2cidr

  
    role              = "slave"
    sync-port         = "port2"
    psk               = var.password
    masterip          = var.vnet2_fgt1_private_ip
    
  }
}

resource "azurerm_virtual_machine" "useast_usse_hub1_fgt2" {
  provider                      = azurerm.usse
  name                         = "useast_usse_hub1_fgt2"
  location                      = azurerm_resource_group.cloudteam_mremini_eastus_usse.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_eastus_usse.name
  network_interface_ids        = [azurerm_network_interface.useast_hub1_usse-fgt2_pub_nic.id, azurerm_network_interface.useast_hub1_usse-fgt2_priv_nic.id]
  primary_network_interface_id = azurerm_network_interface.useast_hub1_usse-fgt2_pub_nic.id
  vm_size                      = var.fgtvnet2_vmsize

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
    name              = "useast_usse_hub1_fgt2_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name = "useast_usse_hub1_fgt2_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option = "Empty"
    lun = 0
    disk_size_gb = "10"
  }


  os_profile {
    computer_name  = "useast-usse-hub1-fgt2"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.useast_usse_hub1_fgt2_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  zones = [2]
    
  boot_diagnostics {
    enabled     = true
    storage_uri = "https://mreminiserial.blob.core.windows.net/"
  }

  tags = {
    Project = "mre_lab"
    Role = "FTNT"
  }

}