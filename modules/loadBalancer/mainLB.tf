resource "azurerm_public_ip" "publicIP" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resourceGroup
  allocation_method   = "Static"
}

resource "azurerm_lb" "loadBalancer" {
  name                = "TestLoadBalancer"
  location            = var.location
  resource_group_name = var.resourceGroup

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicIP.id
  }
}