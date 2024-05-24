variable "private_endpoints" {
  type = set(object({
    tf_id = string

    name                = string
    resource_group_name = string
    location            = string
    subnet_id           = string

    custom_network_interface_name = optional(string)

    tags = optional(map(string))

    private_dns_zone_group = optional(object({
      name                 = optional(string, "pdzg-default")
      private_dns_zone_ids = set(string)
    }))

    private_service_connection = object({
      name                              = optional(string, "psc-default")
      is_manual_connection              = optional(bool, false)
      private_connection_resource_id    = optional(string)
      private_connection_resource_alias = optional(string)
      subresource_names                 = optional(list(string))
      request_message                   = optional(string)
    })

    ip_configuration = optional(object({
      name               = optional(string, "ipc-default")
      private_ip_address = string
      subresource_name   = optional(string)
      member_name        = optional(string)
    }))

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
