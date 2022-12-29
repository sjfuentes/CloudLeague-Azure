 data "azurerm_resource_group" "example" {
  name = var.resourceGroup
}

data "azurerm_subnet" "example" {
  name                 = "private_subnet1"
  virtual_network_name = "CloudLeague-vnet"
  resource_group_name  = var.resourceGroup
}
 
 module "db" {
   source                     = "../../../modules/db"
   location                   = data.azurerm_resource_group.example.location
   resourceGroup              = var.resourceGroup
   subnet-id                  = data.azurerm_subnet.example.id
   container-group-ip-address = "0.0.0.0"
 }