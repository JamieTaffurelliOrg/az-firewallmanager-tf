output "ip_group_id" {
  value       = { for k in azurerm_ip_group.ip_group : k.id => k }
  description = "Resource IDs of the IP Groups"
}

output "base_policy" {
  value       = azurerm_firewall_policy.base_policy
  description = "Base firewall policy"
}

output "base_policy_rule_collection_groups" {
  value       = [for base_policy_rule_collection_group in azurerm_firewall_policy_rule_collection_group.base_policy_rule_collection_group : base_policy_rule_collection_group]
  description = "Base policy rule collection groups"
}
