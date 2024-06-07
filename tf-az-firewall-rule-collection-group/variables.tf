variable "firewall_rule_collection_groups" {
  type = set(object({
    tf_id              = string
    name               = string
    firewall_policy_id = string
    priority           = number

    dnat_rule_collections = optional(list(object({
      name     = string
      priority = number

      rules = list(object({
        name                = string
        description         = optional(string)
        protocols           = string
        source_addresses    = optional(list(string))
        source_ip_groups    = optional(list(string))
        destination_address = optional(string)
        destination_ports   = optional(string)
        translated_address  = optional(string)
        translated_fqdn     = optional(string)
        translated_port     = number
      }))
    })))

    application_rule_collections = optional(list(object({
      name     = string
      action   = string
      priority = number

      rules = list(object({
        name                  = string
        description           = optional(string)
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_addresses = optional(list(string))
        destination_urls      = optional(list(string))
        destination_fqdns     = optional(list(string))
        destination_fqdn_tags = optional(list(string))
        terminate_tls         = optional(string)
        web_categories        = optional(list(string))

        protocols = optional(list(object({
          type = string
          port = number
        })))

        http_headers = optional(list(object({
          name  = string
          value = string
        })))
      }))
    })))

    network_rule_collections = optional(list(object({
      name     = string
      action   = string
      priority = string

      rules = list(object({
        name                  = string
        description           = optional(string)
        protocols             = list(string)
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_ports     = list(string)
        destination_addresses = optional(list(string))
        destination_ip_groups = optional(list(string))
        destination_fqdns     = optional(list(string))
      }))
    })))
  }))

  default = []
}
