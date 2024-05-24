output "route_tables" {
  value = azurerm_route_table.route_tables
}

output "routes" {
  value = azurerm_route.routes
}

output "role_assignments" {
  value = module.role_assignments.role_assignments
}
