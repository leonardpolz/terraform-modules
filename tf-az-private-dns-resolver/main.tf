locals {
  private_dns_resolver_map = { for dnspr in var.private_dns_resolvers : dnspr.tf_id => dnspr }
}

resource "azurerm_private_dns_resolver" "private_dns_resolvers" {
  for_each            = local.private_dns_resolver_map
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  virtual_network_id  = each.value.virtual_network_id
  tags                = each.value.tags
}

module "role_assignments" {
  source = "../tf-az-role-assignment"

  role_assignments = flatten([
    for key, dnspr in local.private_dns_resolver_map : [
      for ra in dnspr.role_assignments : merge(ra, {
        tf_id = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
        scope = azurerm_private_dns_resolver.private_dns_resolvers[key].id
      })
    ] if dnspr.role_assignments != null
  ])
}
