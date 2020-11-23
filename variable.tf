/*variable "TAG" {
    description = "Customer Prefix TAG of the created ressources"
    type= string
}
variable "project" {
    description = "project Prefix TAG of the created ressources"
    type= string
}
*/

variable "azsubscriptionid"{
description = "Azure Subscription id"
}

variable "azsubscriptionid2"{
description = "Azure Subscription id"   // This i to test VNET connection from another subscription
}


//--------------------------------
variable "fgt_vmsize" {
  description = "FGT VM size"
}

variable "fgtvnet2_vmsize" {
  description = "FGT VM size"
}

variable "FGT_IMAGE_SKU" {
  description = "Azure Marketplace default image sku hourly (PAYG 'fortinet_fg-vm_payg_20190624') or byol (Bring your own license 'fortinet_fg-vm')"
}

variable "FGT_VERSION" {
  description = "FortiGate version by default the 'latest' available version in the Azure Marketplace is selected"
}
//------------------------------

variable "username" {
}

variable "password" {
}

//-------------------------------------------------VNET1----------------------------------------

variable "vnet1cidr" {
    description = "VNET1 CIDR"
}

variable "vnet1_pub_subnetcidr" {
    description = "VNET1 FGT Public CIDR"
}
variable "vnet1_priv_subnetcidr" {
    description = "VNET1 FGT Private CIDR"
}
variable "vnet1_ha_subnetcidr" {
    description = "VNET1 FGT HA CIDR"
}
variable "vnet1_mgmt_subnetcidr" {
    description = "VNET1 FGT MGMT CIDR"
}

//-------------------FGT in VNET1----------

variable "vnet1_fgt1_public_ip" {
    description = "FGT1 IP Address for External ENI"
}
variable "vnet1_fgt1_private_ip" {
    description = "FGT1 IP Address for Internal ENI"
}
variable "vnet1_fgt1_ha_ip" {
    description = "FGT1 IP Address for HA ENI"
}
variable "vnet1_fgt1_mgmt_ip"{
    description = "FGT1 IP Address for MGMT ENI"
}

variable "fgt1lic"{
    description = "FGT1 Lic name in case of BYOL, leave empty otherwise"
}

//--------------------------------
variable "vnet1_fgt2_public_ip" {
    description = "FGT2 IP Address for External ENI"
}
variable "vnet1_fgt2_private_ip" {
    description = "FGT2 IP Address for Internal ENI"
}
variable "vnet1_fgt2_ha_ip" {
    description = "FGT2 IP Address for HA ENI"
}
variable "vnet1_fgt2_mgmt_ip"{
    description = "FGT2 IP Address for MGMT ENI"
}

variable "fgt2lic"{
    description = "FGT2 Lic name in case of BYOL, leave empty otherwise"
}

//--------------------------------
variable "vnet1fgtha" {
    description = "Boolean to activate FGT HA config"
}

//-----------------Spokes attached to VNET1------------

variable "spoke1_vnet1cidr" {
    description = "Spoke1  CIDR"
}
variable "spoke1_subnet1" {
    description = "Spoke1 Subnet1"
}
variable "spoke1_subnet2" {
    description = "Spoke1 Subnet2"
}



variable "spoke2_vnet1cidr" {
    description = "Spoke1  CIDR"
}
variable "spoke2_subnet1" {
    description = "Spoke2  Subnet1"
}
variable "spoke2_subnet2" {
    description = "Spoke2  Subnet2"
}

//-----------------VM in Spokes attached to VNET1------------

variable "lnx_vmsize" {
  description = "Linux instances VM size"
}


//--------------------------------------------------------VNET2----------------------------------------

variable "vnet2cidr" {
    description = "VNET2 CIDR"
}
variable "vnet2_pub_subnetcidr" {
    description = "VNET2 FGT Public subnet CIDR"
}
variable "vnet2_priv_subnetcidr" {
    description = "VNET2 FGT Private subnet CIDR"
}
variable "vnet2_backend1_subnetcidr" {
    description = "VNET2 Backend Serves subnet CIDR"
}
variable "vnet2_backend2_subnetcidr" {
    description = "VNET2 Backend Serves subnet CIDR"
}
//-------------------FGT in VNET2----------

variable "vnet2_fgt1_public_ip" {
    description = "FGT1 IP Address for External ENI"
}
variable "vnet2_fgt1_private_ip" {
    description = "FGT1 IP Address for Internal ENI"
}
variable "eastussefgt1lic"{
    description = "FGT1 Lic name in case of BYOL, leave empty otherwise"
}
//-----------------------------

variable "vnet2_fgt2_public_ip" {
    description = "FGT2 IP Address for External ENI"
}
variable "vnet2_fgt2_private_ip" {
    description = "FGT2 IP Address for Internal ENI"
}
variable "eastussefgt2lic"{
    description = "FGT2 Lic name in case of BYOL, leave empty otherwise"
}

