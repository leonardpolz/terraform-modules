output "private_dns_zones" {
  value = azurerm_private_dns_zone.private_dns_zones
}

output "role_assignments" {
  value = module.role_assignments.role_assignments
}
