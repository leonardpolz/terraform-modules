locals {
  workload_map = { for rcg in var.firewall_rule_collection_groups : rcg.tf_id => rcg }
}

resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_groups" {
  for_each           = local.workload_map
  name               = each.value.name
  firewall_policy_id = each.value.firewall_policy_id
  priority           = each.value.priority

  dynamic "nat_rule_collection" {
    for_each = each.value.dnat_rule_collections != null ? each.value.dnat_rule_collections : []
    content {
      name     = nat_rule_collection.value.name
      action   = "Dnat"
      priority = nat_rule_collection.value.priority

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules != null ? nat_rule_collection.value.rules : []
        content {
          name                = rule.value.name
          description         = rule.value.description
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          source_ip_groups    = rule.value.source_ip_groups
          destination_address = rule.value.destination_address
          destination_ports   = rule.value.destination_ports
          translated_address  = rule.value.translated_address
          translated_fqdn     = rule.value.translated_fqdn
          translated_port     = rule.value.translated_port
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = each.value.application_rule_collections != null ? each.value.application_rule_collections : []
    content {
      name     = application_rule_collection.value.name
      action   = application_rule_collection.value.action
      priority = application_rule_collection.value.priority

      dynamic "rule" {
        for_each = application_rule_collection.value.rules != null ? application_rule_collection.value.rules : []
        content {
          name                  = rule.value.name
          description           = rule.value.description
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_addresses = rule.value.destination_addresses
          destination_urls      = rule.value.destination_urls
          destination_fqdns     = rule.value.destination_fqdns
          destination_fqdn_tags = rule.value.destination_fqdn_tags
          terminate_tls         = rule.value.terminate_tls
          web_categories        = rule.value.web_categories

          dynamic "protocols" {
            for_each = rule.value.protocols != null ? rule.value.protocols : []
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }

          dynamic "http_headers" {
            for_each = rule.value.http_headers != null ? rule.value.http_headers : []
            content {
              name  = http_headers.value.name
              value = http_headers.value.value
            }
          }
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = each.value.network_rule_collections != null ? each.value.network_rule_collections : []
    content {
      name     = network_rule_collection.value.name
      action   = network_rule_collection.value.action
      priority = network_rule_collection.value.priority

      dynamic "rule" {
        for_each = network_rule_collection.value.rules != null ? network_rule_collection.value.rules : []
        content {
          name                  = rule.value.name
          description           = rule.value.description
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_ports     = rule.value.destination_ports
          destination_addresses = rule.value.destination_addresses
          destination_ip_groups = rule.value.destination_ip_groups
          destination_fqdns     = rule.value.destination_fqdns
        }
      }
    }
  }
}
