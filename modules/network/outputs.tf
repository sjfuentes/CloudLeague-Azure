output "virtualNetworkId" {
    value = azurerm_virtual_network.vnet.id
}

output "subnet1-id" {
    value = azurerm_subnet.private_subnet1.id
}