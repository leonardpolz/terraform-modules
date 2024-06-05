provider "azurerm" {
  features {}
}

variables {
  private_dns_resolvers = [{
    tf_id = "test_dns_resolver"

    name                = "test-dns-resolver"
    resource_group_name = "test-rg"
    location            = "westeurope"
    virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"

    tags = {
      terraform_repository_uri = "test.git"
      deployed_by              = "test"
      hidden-title             = "Test Resource Group"
    }
  }]
}

run "plan" {

  command = plan

  assert {
    condition     = azurerm_private_dns_resolver.private_dns_resolvers["test_dns_resolver"].name == "test-dns-resolver"
    error_message = "Private DNS resolver name '${azurerm_private_dns_resolver.private_dns_resolvers["test_dns_resolver"].name}' does not match expected value 'test-dns-resolver'"
  }

  assert {
    condition     = azurerm_private_dns_resolver.private_dns_resolvers["test_dns_resolver"].resource_group_name == "test-rg"
    error_message = "Private DNS resolver resource group name '${azurerm_private_dns_resolver.private_dns_resolvers["test_dns_resolver"].resource_group_name}' does not match expected value 'test-rg'"
  }

  assert {
    condition     = azurerm_private_dns_resolver.private_dns_resolvers["test_dns_resolver"].location == "westeurope"
    error_message = "Private DNS resolver location '${azurerm_private_dns_resolver.private_dns_resolvers["test_dns_resolver"].location}' does not match expected value 'westeurope'"
  }

  assert {
    condition     = azurerm_private_dns_resolver.private_dns_resolvers["test_dns_resolver"].virtual_network_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
    error_message = "Private DNS resolver virtual network ID '${azurerm_private_dns_resolver.private_dns_resolvers["test_dns_resolver"].virtual_network_id}' does not match expected value '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet'"
  }
}
