provider "azurerm" {
  features {}
}

variables {
  firewall_rule_collection_groups = [{
    tf_id = "test_frcg"

    name               = "test-frcg"
    firewall_policy_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/firewallPolicies/firewallPolicyValue"
    priority           = 100
  }]
}

run "plan" {

  command = plan

  assert {
    condition     = azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].name == "test-frcg"
    error_message = "Firewall rule collection group name '${azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].name}' does not match expected value 'test-frcg'"
  }

  assert {
    condition     = azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].firewall_policy_id == "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/firewallPolicies/firewallPolicyValue"
    error_message = "Firewall rule collection group firewall policy ID '${azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].firewall_policy_id}' does not match expected value '/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/firewallPolicies/firewallPolicyValue'"
  }

  assert {
    condition     = azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].priority == 100
    error_message = "Firewall rule collection group priority '${azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].priority}' does not match expected value '100'"
  }
}
