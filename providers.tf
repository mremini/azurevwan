provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.35.0"
  subscription_id = var.azsubscriptionid
  features {}
}

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.35.0"
  subscription_id = var.azsubscriptionid2
  alias= "usse"
  features {}
}