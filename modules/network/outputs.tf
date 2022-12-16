output "virtualNetworkName" {
    value = azurerm_virtual_network.vnet.name
}

output "subnet1-id" {
    value = azurerm_subnet.private_subnet1.id
}