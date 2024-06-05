locals {
  resource_group_map = { for rg in var.resource_groups : rg.tf_id => rg }
}

resource "azurerm_resource_group" "resource_groups" {
  for_each   = local.resource_group_map
  name       = each.value.name
  location   = each.value.location
  managed_by = each.value.managed_by
  tags       = each.value.tags
}

module "role_assignments" {
  source = "../tf-az-role-assignment"

  role_assignments = flatten([
    for key, rg in local.resource_group_map : [
      for ra in rg.role_assignments : merge(ra, {
        tf_id = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
        scope = azurerm_resource_group.resource_groups[key].id
      })
    ] if rg.role_assignments != null
  ])
}

