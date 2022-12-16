resource "azurerm_subnet" "private_subnet1" {
  name                 = "private_subnet1"
  resource_group_name  = var.resourceGroup
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}