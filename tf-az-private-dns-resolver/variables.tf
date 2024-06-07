variable "private_dns_resolvers" {
  type = set(object({
    tf_id = string

    name                = string
    resource_group_name = string
    location            = string
    virtual_network_id  = string
    tags                = optional(map(string))

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

    inbound_endpoints = optional(set(object({
      tf_id = string

      name = string
      tags = optional(map(string))

      ip_configurations = set(object({
        subnet_id                    = string
        private_ip_address           = optional(string)
        private_ip_allocation_method = optional(string)
      }))
    })))
  }))

  default = []
}
