resource "azurerm_ip_group" "ip_group" {
    for_each            = { for k in var.ip_groups : k.name => k if k != null }
  name                = each.group
  location            = var.location
  resource_group_name = var.resource_group_name
  cidrs = each.value.cidr_ranges
  tags = var.tags
}

resource "azurerm_firewall_policy" "base_policy" {
  name                = var.base_policy_name
  resource_group_name = var.resource_group_name
  location            = var.location

  insights {
    enabled                            = true
    default_log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id
    retention_in_days                  = 365
  }

  intrusion_detection {
    mode = var.intrusion_detection_mode
  }
}
