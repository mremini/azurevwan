
azsubscriptionid = "" // APAC SE Subscription
azsubscriptionid2 ="" // US SE Subscription


fgt_vmsize = "Standard_F8s_v2"
fgtvnet2_vmsize = "Standard_F2s_v2"
FGT_IMAGE_SKU= "fortinet_fg-vm"
FGT_VERSION = "6.4.2"

lnx_vmsize= "Standard_D2_v3"

username =  "xxxxxx"  // Cutomize with your own username
password =  "xxxxxx"  // Customize with your own psswd


vnet1cidr ="10.70.0.0/16"
vnet1_pub_subnetcidr= "10.70.4.0/24"
vnet1_priv_subnetcidr="10.70.5.0/24"
vnet1_ha_subnetcidr="10.70.6.0/24"
vnet1_mgmt_subnetcidr="10.70.7.0/24"
vnet1fgtha = "true"

vnet1_fgt1_public_ip="10.70.4.4"
vnet1_fgt1_private_ip="10.70.5.4"
vnet1_fgt1_ha_ip="10.70.6.4"
vnet1_fgt1_mgmt_ip="10.70.7.4"
fgt1lic= "./assets/fgt1.lic"

vnet1_fgt2_public_ip="10.70.4.5"
vnet1_fgt2_private_ip="10.70.5.5"
vnet1_fgt2_ha_ip="10.70.6.5"
vnet1_fgt2_mgmt_ip="10.70.7.5"
fgt2lic= "./assets/fgt2.lic"

spoke1_vnet1cidr ="10.72.0.0/16"
spoke1_subnet1="10.72.0.0/24"
spoke1_subnet2="10.72.1.0/24"

spoke2_vnet1cidr="10.75.0.0/16"
spoke2_subnet1= "10.75.0.0/24"
spoke2_subnet2= "10.75.1.0/24"



vnet2cidr ="10.71.0.0/16"
vnet2_pub_subnetcidr= "10.71.4.0/24"
vnet2_priv_subnetcidr="10.71.5.0/24"
vnet2_backend1_subnetcidr = "10.71.15.0/24"
vnet2_backend2_subnetcidr = "10.71.16.0/24"

vnet2_fgt1_public_ip="10.71.4.4"
vnet2_fgt1_private_ip="10.71.5.4"
eastussefgt1lic = "./assets/eastussefgt1.lic"

vnet2_fgt2_public_ip="10.71.4.5"
vnet2_fgt2_private_ip="10.71.5.5"
eastussefgt2lic = "./assets/eastussefgt2.lic"

