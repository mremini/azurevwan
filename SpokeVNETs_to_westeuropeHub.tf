//############################ Create Spoke VNETs ##################

resource "azurerm_virtual_network" "mre_az_westeu_spoke1" {
  name                = "mre_az_westeu_spoke1"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
  address_space       = [var.spoke1_vnet1cidr]
  

  tags = {
    Project = "mre_lab"
    Role = "SpokeVNET"
  }
}

resource "azurerm_virtual_network" "mre_az_westeu_spoke2" {
  name                = "mre_az_westeu_spoke2"
  location            = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name = azurerm_resource_group.cloudteam_mremini_westeu.name
  address_space       = [var.spoke2_vnet1cidr]
  

  tags = {
    Project = "mre_lab"
    Role = "SpokeVNET"
  }
}

//############################ Create Spoke Subnets ##################

resource "azurerm_subnet" "mre_az_westeu_spoke1_subnet1" {
  name                 = "mre_az_westeu_spoke1_subnet1"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_westeu_spoke1.name
  address_prefixes     = [var.spoke1_subnet1]

}
resource "azurerm_subnet" "mre_az_westeu_spoke1_subnet2" {
  name                 = "mre_az_westeu_spoke1_subnet2"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_westeu_spoke1.name
  address_prefixes     = [var.spoke1_subnet2]

}

resource "azurerm_subnet" "mre_az_westeu_spoke2_subnet1" {
  name                 = "mre_az_westeu_spoke2_subnet1"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_westeu_spoke2.name
  address_prefixes     = [var.spoke2_subnet1]

}
resource "azurerm_subnet" "mre_az_westeu_spoke2_subnet2" {
  name                 = "mre_az_westeu_spoke2_subnet2"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_westeu_spoke2.name
  address_prefixes     = [var.spoke2_subnet2]

}

//############################ UDRs ##################

resource "azurerm_route_table" "mre_az_westeu_spoke1_RTB" {
  name                          = "mre_az_westeu_spoke1_RTB"
  location                      = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_westeu.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}
resource "azurerm_subnet_route_table_association" "mre_az_westeu_spoke1_subnet1_RTB_assoc" {
  subnet_id      = azurerm_subnet.mre_az_westeu_spoke1_subnet1.id
  route_table_id = azurerm_route_table.mre_az_westeu_spoke1_RTB.id
}
resource "azurerm_subnet_route_table_association" "mre_az_westeu_spoke1_subnet2_RTB_assoc" {
  subnet_id      = azurerm_subnet.mre_az_westeu_spoke1_subnet2.id
  route_table_id = azurerm_route_table.mre_az_westeu_spoke1_RTB.id
}


resource "azurerm_route_table" "mre_az_westeu_spoke2_RTB" {
  name                          = "mre_az_westeu_spoke2_RTB"
  location                      = azurerm_resource_group.cloudteam_mremini_westeu.location
  resource_group_name           = azurerm_resource_group.cloudteam_mremini_westeu.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "mre_lab"
  }
}

resource "azurerm_subnet_route_table_association" "mre_az_westeu_spoke2_subnet1_RTB_assoc" {
  subnet_id      = azurerm_subnet.mre_az_westeu_spoke2_subnet1.id
  route_table_id = azurerm_route_table.mre_az_westeu_spoke2_RTB.id
}
resource "azurerm_subnet_route_table_association" "mre_az_westeu_spoke2_subnet2_RTB_assoc" {
  subnet_id      = azurerm_subnet.mre_az_westeu_spoke2_subnet2.id
  route_table_id = azurerm_route_table.mre_az_westeu_spoke2_RTB.id
}



//############################ Peerings with VNET1 Hub ##################
resource "azurerm_virtual_network_peering" "mre_az_westeu_hub1_to_spoke1" {
  name                      = "mre_az_westeu_hub1_to_spoke1"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_hub1_useast.name                               // Type in the name, should be mre_az_westeu_hub1
  remote_virtual_network_id = azurerm_virtual_network.mre_az_westeu_spoke1.id

   allow_virtual_network_access = true
   allow_forwarded_traffic      = true


}

resource "azurerm_virtual_network_peering" "mre_az_westeu_spoke1_to_hub1" {
  name                      = "mre_az_westeu_spoke1_to_hub1"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_westeu_spoke1.name                               
  remote_virtual_network_id = azurerm_virtual_network.mre_az_hub1_useast.id

   allow_virtual_network_access = true
   allow_forwarded_traffic      = true

}

resource "azurerm_virtual_network_peering" "mre_az_westeu_hub1_to_spoke2" {
  name                      = "mre_az_westeu_hub1_to_spoke2"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_hub1_useast.name                               // Type in the name, should be mre_az_westeu_hub1
  remote_virtual_network_id = azurerm_virtual_network.mre_az_westeu_spoke2.id

   allow_virtual_network_access = true
   allow_forwarded_traffic      = true


}

resource "azurerm_virtual_network_peering" "mre_az_westeu_spoke2_to_hub1" {
  name                      = "mre_az_westeu_spoke2_to_hub1"
  resource_group_name  = azurerm_resource_group.cloudteam_mremini_westeu.name
  virtual_network_name = azurerm_virtual_network.mre_az_westeu_spoke2.name                               
  remote_virtual_network_id = azurerm_virtual_network.mre_az_hub1_useast.id

   allow_virtual_network_access = true
   allow_forwarded_traffic      = true

}
