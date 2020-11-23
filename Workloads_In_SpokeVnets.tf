/*
//############################ Create NSG ##################

resource "azurerm_network_security_group" "mre_az_westeu_spoke1-lnx1" {
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
  
}*/



//############################ Create Linux VMs Hub1 ##################

data "template_file" "lnx_customdata" {
  template = "./assets/lnx-spoke.tpl"

  vars = {
  }
}

///////////////////LNX1 - K8S Master

resource "azurerm_network_interface" "mre_az_westeu_spoke1-lnx1-port1" {
  name                            = "mre_az_westeu_spoke1-lnx1-port1"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name

  enable_ip_forwarding            = false
  enable_accelerated_networking   = false
  //network_security_group_id = "${azurerm_network_security_group.fgt_nsg.id}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.mre_az_westeu_spoke1_subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "mre_az_westeu_spoke1-lnx1" {
  name                  = "mre_az_westeu_spoke1-lnx1"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name

  network_interface_ids = [azurerm_network_interface.mre_az_westeu_spoke1-lnx1-port1.id]
  vm_size               = var.lnx_vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "mre_az_westeu_spoke1-lnx1-OSDISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "mre-az-westeu-spoke1-lnx1"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.lnx_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "https://mrefgtserialconsole.blob.core.windows.net/"
  }

  zones = [1]

  tags = { 
    Project = "mre_lab"
    Role = "K8S-Master"
    server = "ubuntu"
  }

     //   provisioner "file" {
     //  source      = "./assets/k8s"
    //  destination = "/home/ubuntu/calico"
    // }

}

///////////////////LNX2 - K8S Worker

resource "azurerm_network_interface" "mre_az_westeu_spoke1-lnx2-port1" {
  name                            = "mre_az_westeu_spoke1-lnx2-port1"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name

  enable_ip_forwarding            = false
  enable_accelerated_networking   = false
  //network_security_group_id = "${azurerm_network_security_group.fgt_nsg.id}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.mre_az_westeu_spoke1_subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "mre_az_westeu_spoke1-lnx2" {
  name                  = "mre_az_westeu_spoke1-lnx2"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name

  network_interface_ids = [azurerm_network_interface.mre_az_westeu_spoke1-lnx2-port1.id]
  vm_size               = var.lnx_vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "mre_az_westeu_spoke1-lnx2-OSDISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "mre-az-westeu-spoke1-lnx2"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.lnx_customdata.rendered
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
    Role = "K8S-Worker"
    server = "ubuntu"
  }
  
     //   provisioner "file" {
     //  source      = "./assets/k8s"
    //  destination = "/home/ubuntu/calico"
    // }
  
}


///////////////////LNX3 - K8S Worker

resource "azurerm_network_interface" "mre_az_westeu_spoke1-lnx3-port1" {
  name                            = "mre_az_westeu_spoke1-lnx3-port1"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name

  enable_ip_forwarding            = false
  enable_accelerated_networking   = false
  //network_security_group_id = "${azurerm_network_security_group.fgt_nsg.id}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.mre_az_westeu_spoke1_subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "mre_az_westeu_spoke1-lnx3" {
  name                  = "mre_az_westeu_spoke1-lnx3"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name

  network_interface_ids = [azurerm_network_interface.mre_az_westeu_spoke1-lnx3-port1.id]
  vm_size               = var.lnx_vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "mre_az_westeu_spoke1-lnx3-OSDISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "mre-az-westeu-spoke1-lnx3"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.lnx_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "https://mrefgtserialconsole.blob.core.windows.net/"
  }

  zones = [3]

  tags = { 
    Project = "mre_lab"
    Role = "K8S-Worker"
    server = "ubuntu"
  }

     //   provisioner "file" {
     //  source      = "./assets/k8s"
    //  destination = "/home/ubuntu/calico"
    // }

}