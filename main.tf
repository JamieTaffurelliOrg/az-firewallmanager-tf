resource "azurerm_ip_group" "ip_group" {
  for_each            = { for k in var.ip_groups : k.name => k if k != null }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  cidrs               = each.value.cidr_ranges
  tags                = var.tags
}

resource "azurerm_firewall_policy" "base_policy" {
  name                     = var.base_policy_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.base_policy_sku
  threat_intelligence_mode = var.threat_intelligence_mode

  threat_intelligence_allowlist {
    fqdns        = var.threat_intelligence_allowed_fqdns
    ip_addresses = var.threat_intelligence_allowed_ip_addresses
  }

  insights {
    enabled                            = true
    default_log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id
    retention_in_days                  = 365
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "base_policy_rule_collection_group" {
  for_each           = { for k in var.base_policy_rule_collection_groups : k.name => k if k != null }
  name               = each.key
  firewall_policy_id = azurerm_firewall_policy.base_policy.id
  priority           = each.value["priority"]

  dynamic "application_rule_collection" {
    for_each = { for k in each.value["application_rule_collections"] : k.name => k if k != null }

    content {
      name     = application_rule_collection.key
      priority = application_rule_collection.value["priority"]
      action   = application_rule_collection.value["action"]

      dynamic "rule" {
        for_each = { for k in application_rule_collection.value["rules"] : k.name => k }

        content {
          name                  = rule.key
          description           = rule.value["description"]
          source_addresses      = rule.value["source_addresses"]
          source_ip_groups      = lookup(rule.value, "source_ip_group_references", null) == null ? null : [for k in setintersection(local.deployed_ip_groups_names, rule.value["source_ip_group_references"]) : azurerm_ip_group.ip_group[(k)].id]
          destination_fqdns     = rule.value["destination_fqdns"]
          destination_fqdn_tags = rule.value["destination_fqdn_tags"]

          dynamic "protocols" {
            for_each = rule.value["protocols"]

            content {
              type = protocols.value["type"]
              port = protocols.value["port"]
            }
          }
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = { for k in each.value["network_rule_collections"] : k.name => k if k != null }

    content {
      name     = network_rule_collection.key
      priority = network_rule_collection.value["priority"]
      action   = network_rule_collection.value["action"]

      dynamic "rule" {
        for_each = { for k in network_rule_collection.value["rules"] : k.name => k }

        content {
          name                  = rule.key
          source_addresses      = rule.value["source_addresses"]
          source_ip_groups      = lookup(rule.value, "source_ip_group_references", null) == null ? null : [for k in setintersection(local.deployed_ip_groups_names, rule.value["source_ip_group_references"]) : azurerm_ip_group.ip_group[(k)].id]
          destination_addresses = lookup(rule.value, "destination_addresses", null) == null ? null : rule.value["destination_addresses"]
          destination_fqdns     = lookup(rule.value, "destination_fqdns", null) == null ? null : rule.value["destination_fqdns"]
          destination_ip_groups = lookup(rule.value, "destination_ip_group_references", null) == null ? null : [for k in setintersection(local.deployed_ip_groups_names, rule.value["destination_ip_group_references"]) : azurerm_ip_group.ip_group[(k)].id]
          protocols             = rule.value["protocols"]
          destination_ports     = rule.value["destination_ports"]
        }
      }
    }
  }
}
