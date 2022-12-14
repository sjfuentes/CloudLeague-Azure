resource "azurerm_virtual_network" "vnet" {
    name = "CloudLeague-vnet"
    address_space = [ "10.0.0.0/16" ]
    location = var.location
    resource_group_name = "1-55a4b655-playground-sandbox"
    tags = {
      Environment = "test"
      Team = "Cloud-League"
    }
}