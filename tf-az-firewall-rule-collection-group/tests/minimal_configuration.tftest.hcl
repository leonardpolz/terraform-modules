provider "azurerm" {
  features {}
}

variables {
  firewall_rule_collection_groups = [{
    tf_id = "test_frcg"

    name               = "test-frcg"
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/azureFirewalls/test-fw/firewallPolicies/test-fwp"
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
    condition     = azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].firewall_policy_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/azureFirewalls/test-fw/firewallPolicies/test-fwp"
    error_message = "Firewall policy ID '${azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].firewall_policy_id}' does not match expected value '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/azureFirewalls/test-fw/firewallPolicies/test-fwp'"
  }

  assert {
    condition     = azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].priority == 100
    error_message = "Firewall rule collection group priority '${azurerm_firewall_policy_rule_collection_group.rule_collection_groups["test_frcg"].priority}' does not match expected value '100'"
  }
}
