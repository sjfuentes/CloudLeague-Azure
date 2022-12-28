resource "azurerm_public_ip" "publicIP" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resourceGroup
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "loadBalancer" {
  name                = "TestLoadBalancer"
  location            = var.location
  resource_group_name = var.resourceGroup
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicIP.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {
  loadbalancer_id = azurerm_lb.loadBalancer.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "poolAddress" {
  name                    = "example"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
  virtual_network_id      = var.virtual-network-id
  ip_address              = var.container-group-ip-address
}
