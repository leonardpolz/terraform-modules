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

locals {
  inbound_endpoint_list = flatten([
    for key, dnspr in local.private_dns_resolver_map : [
      for ie in dnspr.inbound_endpoints != null ? dnspr.inbound_endpoints : [] : merge(
        ie, {
          tf_id       = "${key}_${ie.tf_id}"
          dnspr_tf_id = key
        }
      )
    ]
  ])
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_endpoints" {
  for_each                = { for ie in local.inbound_endpoint_list : ie.tf_id => ie }
  name                    = each.value.name
  private_dns_resolver_id = resource.azurerm_private_dns_resolver.private_dns_resolvers[each.value.dnspr_tf_id].id
  location                = resource.azurerm_private_dns_resolver.private_dns_resolvers[each.value.dnspr_tf_id].location
  tags                    = each.value.tags

  dynamic "ip_configurations" {
    for_each = [each.value.ip_configurations]
    content {
      subnet_id                    = ip_configurations.value.subnet_id
      private_ip_address           = ip_configurations.value.private_ip_address
      private_ip_allocation_method = ip_configurations.value.private_ip_allocation_method
    }
  }
}
