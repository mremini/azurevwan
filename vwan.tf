//############################ Create vWAN RG ##################


resource "azurerm_resource_group" "cloudteam_mremini_vWAN" {
  name     = "cloudteam_mremini_vWAN"
  location = "eastus"
}


//############################ Create vWAN  ##################

resource "azurerm_virtual_wan" "cloudteam_mremini_vWAN" {
  name                = "cloudteam_mremini_vWAN"
  resource_group_name = azurerm_resource_group.cloudteam_mremini_vWAN.name
  location            = azurerm_resource_group.cloudteam_mremini_vWAN.location
  type                = "Standard"
  allow_branch_to_branch_traffic    ="true" 

    tags = {
        Project = "mre_lab"
        Role = "vWAN"
    }


}

//############################ Create vWAN Hubs ##################

////////////// West EU
resource "azurerm_virtual_hub" "westeu_vHub" {
  name                = "westeu_vHub"
  resource_group_name = azurerm_resource_group.cloudteam_mremini_vWAN.name
  location            = "westeurope"
  virtual_wan_id      = azurerm_virtual_wan.cloudteam_mremini_vWAN.id
  address_prefix      = "10.80.0.0/24"
}

resource "azurerm_virtual_hub_route_table" "westeu_vHub_rtb" {
  name           = "westeu_vHub_RTB"
  virtual_hub_id = azurerm_virtual_hub.westeu_vHub.id

}
////////////// EAST US

resource "azurerm_virtual_hub" "eastus_vHub" {
  name                = "eastus_vHub"
  resource_group_name = azurerm_resource_group.cloudteam_mremini_vWAN.name
  location            = "eastus"
  virtual_wan_id      = azurerm_virtual_wan.cloudteam_mremini_vWAN.id
  address_prefix      = "10.80.1.0/24"
}

resource "azurerm_virtual_hub_route_table" "eastus_vHub_rtb" {
  name           = "eastus_vHub_RTB"
  virtual_hub_id = azurerm_virtual_hub.eastus_vHub.id

}

//############################ Attach VNETs to vHUBS ##################

resource "azurerm_virtual_hub_connection" "westeu_vnet_to_westeu_vHub" {
  name                      = "westeu_vnet_to_westeu_vHub"
  virtual_hub_id            = azurerm_virtual_hub.westeu_vHub.id
  remote_virtual_network_id = azurerm_virtual_network.mre_az_hub1_useast.id  //typo in the name of the vnet , should be mre_az_westeu_hub1 to highlight real region name
  
  routing  {
      associated_route_table_id = azurerm_virtual_hub_route_table.westeu_vHub_rtb.id
      propagated_route_table {
        route_table_ids= [azurerm_virtual_hub_route_table.westeu_vHub_rtb.id, azurerm_virtual_hub_route_table.eastus_vHub_rtb.id]
      }
    }
}



resource "azurerm_virtual_hub_connection" "eastus_vnet_to_eastus_vHub" {
  name                      = "eastus_vnet_to_eastus_vHub"
  virtual_hub_id            = azurerm_virtual_hub.eastus_vHub.id
  remote_virtual_network_id = azurerm_virtual_network.mre_az_eastus_hub1_usse.id 
  
  routing  {
      associated_route_table_id = azurerm_virtual_hub_route_table.eastus_vHub_rtb.id
      propagated_route_table {
        route_table_ids= [azurerm_virtual_hub_route_table.westeu_vHub_rtb.id, azurerm_virtual_hub_route_table.eastus_vHub_rtb.id]
      }
    }
}




