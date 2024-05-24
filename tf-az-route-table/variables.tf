variable "route_tables" {
  type = set(object({
    tf_id = string

    name                          = string
    resource_group_name           = string
    location                      = string
    disable_bgp_route_propagation = optional(bool)
    tags                          = optional(map(string))

    routes = optional(set(object({
      tf_id                  = string
      name                   = optional(string)
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })))

    role_assignments = optional(set(object({
      tf_id                                  = optional(string)
      principal_id                           = string
      name                                   = optional(string)
      role_definition_id                     = optional(string)
      role_definition_name                   = optional(string)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      description                            = optional(string)
      skip_service_principal_aad_check       = optional(bool)
    })))
  }))

  default = []
}
