# az-firewallmanager-tf

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.37.0 |
| <a name="provider_azurerm.logs"></a> [azurerm.logs](#provider\_azurerm.logs) | 3.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy.base_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy.child_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.base_policy_rule_collection_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_ip_group.ip_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ip_group) | resource |
| [azurerm_log_analytics_workspace.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_policy_name"></a> [base\_policy\_name](#input\_base\_policy\_name) | Base firewall policy | `string` | n/a | yes |
| <a name="input_base_policy_rule_collection_groups"></a> [base\_policy\_rule\_collection\_groups](#input\_base\_policy\_rule\_collection\_groups) | Base rule collection groups to deploy | <pre>list(object(<br>    {<br>      name     = string<br>      priority = number<br>      application_rule_collections = list(object(<br>        {<br>          name     = string<br>          priority = number<br>          action   = string<br>          rules = list(object(<br>            {<br>              name                       = string<br>              description                = string<br>              source_addresses           = optional(list(string))<br>              source_ip_group_references = optional(list(string))<br>              destination_fqdns          = optional(list(string))<br>              destination_fqdn_tags      = optional(list(string))<br>              protocols = map(object(<br>                {<br>                  type = string<br>                  port = number<br>                }<br>              ))<br>            }<br>          ))<br>        }<br>      ))<br>      network_rule_collections = list(object(<br>        {<br>          name     = string<br>          priority = number<br>          action   = string<br>          rules = list(object(<br>            {<br>              name                            = string<br>              description                     = string<br>              source_addresses                = optional(list(string))<br>              source_ip_group_references      = optional(list(string))<br>              destination_addresses           = optional(list(string))<br>              destination_fqdns               = optional(list(string))<br>              destination_ip_group_references = optional(list(string))<br>              protocols                       = list(string)<br>              destination_ports               = list(string)<br>            }<br>          ))<br>        }<br>      ))<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_base_policy_sku"></a> [base\_policy\_sku](#input\_base\_policy\_sku) | Base firewall policy sku, Basic or Standard | `string` | `"Standard"` | no |
| <a name="input_child_policies"></a> [child\_policies](#input\_child\_policies) | Child policies to deploy | <pre>list(object(<br>    {<br>      name                                     = string<br>      threat_intelligence_mode                 = optional(string, "Deny")<br>      threat_intelligence_allowed_fqdns        = optional(list(string), [])<br>      threat_intelligence_allowed_ip_addresses = optional(list(string), [])<br>      dns = optional(object({<br>        proxy_enabled = bool<br>        servers       = optional(list(string))<br>      }))<br>  }))</pre> | `[]` | no |
| <a name="input_dns"></a> [dns](#input\_dns) | Firewall DNS settings | <pre>object({<br>    proxy_enabled = bool<br>    servers       = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_intrusion_detection"></a> [intrusion\_detection](#input\_intrusion\_detection) | IDPS settings | <pre>object({<br>    enabled        = optional(bool, false)<br>    mode           = optional(string, "Deny")<br>    private_ranges = optional(list(string))<br>    signature_overrides = optional(list(object({<br>      id   = string<br>      mode = optional(string, "Deny")<br>    })))<br>    traffic_bypass = optional(list(object({<br>      name                  = string<br>      protocol              = optional(string, "TCP")<br>      description           = string<br>      destination_addresses = optional(list(string))<br>      destination_ip_groups = optional(list(string))<br>      destination_ports     = optional(list(string))<br>      source_addresses      = optional(list(string))<br>      source_ip_groups      = optional(list(string))<br>    })))<br>  })</pre> | `{}` | no |
| <a name="input_ip_groups"></a> [ip\_groups](#input\_ip\_groups) | IP groups to deploy | <pre>list(object(<br>    {<br>      name        = string<br>      cidr_ranges = list(string)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the Virtual Network | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Resource Group of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group name to deploy to | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | n/a | yes |
| <a name="input_threat_intelligence_allowed_fqdns"></a> [threat\_intelligence\_allowed\_fqdns](#input\_threat\_intelligence\_allowed\_fqdns) | Threat intelligence allowed FQDNs | `list(string)` | `[]` | no |
| <a name="input_threat_intelligence_allowed_ip_addresses"></a> [threat\_intelligence\_allowed\_ip\_addresses](#input\_threat\_intelligence\_allowed\_ip\_addresses) | Threat intelligence allowed ip\_addresses | `list(string)` | `[]` | no |
| <a name="input_threat_intelligence_mode"></a> [threat\_intelligence\_mode](#input\_threat\_intelligence\_mode) | Threat intelligence mode, Off, Alert or Deny | `string` | `"Deny"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base_policy"></a> [base\_policy](#output\_base\_policy) | Base firewall policy |
| <a name="output_base_policy_rule_collection_groups"></a> [base\_policy\_rule\_collection\_groups](#output\_base\_policy\_rule\_collection\_groups) | Base policy rule collection groups |
| <a name="output_ip_group_id"></a> [ip\_group\_id](#output\_ip\_group\_id) | Resource IDs of the IP Groups |
<!-- END_TF_DOCS -->
