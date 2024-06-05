output "private_dns_resolvers" {
  value = azurerm_private_dns_resolver.private_dns_resolvers
}

output "role_assignments" {
  value = module.role_assignments.role_assignments
}
