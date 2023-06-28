variable "resource_group_name" {
  type        = string
  description = "Resource Group name to deploy to"
}

variable "location" {
  type        = string
  description = "Location of the Virtual Network"
}

variable "ip_groups" {
  type = list(object(
    {
      name        = string
      cidr_ranges = list(string)
    }
  ))
  default     = []
  description = "IP groups to deploy"
}

variable "base_policy_name" {
  type        = string
  description = "Base firewall policy "
}

variable "base_policy_sku" {
  type        = string
  default     = "Standard"
  description = "Base firewall policy sku, Basic or Standard"
}

variable "threat_intelligence_mode" {
  type        = string
  default     = "Deny"
  description = "Threat intelligence mode, Off, Alert or Deny"
}

variable "threat_intelligence_allowed_fqdns" {
  type        = list(string)
  default     = []
  description = "Threat intelligence allowed FQDNs"
}

variable "threat_intelligence_allowed_ip_addresses" {
  type        = list(string)
  default     = []
  description = "Threat intelligence allowed ip_addresses"
}

variable "intrusion_detection" {
  type = object({
    enabled        = optional(bool, false)
    mode           = optional(string, "Deny")
    private_ranges = optional(list(string))
    signature_overrides = optional(list(object({
      id   = string
      mode = optional(string, "Deny")
    })))
    traffic_bypass = optional(list(object({
      name                  = string
      protocol              = optional(string, "TCP")
      description           = string
      destination_addresses = optional(list(string))
      destination_ip_groups = optional(list(string))
      destination_ports     = optional(list(string))
      source_addresses      = optional(list(string))
      source_ip_groups      = optional(list(string))
    })))
  })
  default     = {}
  description = "IDPS settings"
}

variable "base_policy_rule_collection_groups" {
  type = list(object(
    {
      name     = string
      priority = number
      application_rule_collections = list(object(
        {
          name     = string
          priority = number
          action   = string
          rules = list(object(
            {
              name                       = string
              description                = string
              source_addresses           = optional(list(string))
              source_ip_group_references = optional(list(string))
              destination_fqdns          = optional(list(string))
              destination_fqdn_tags      = optional(list(string))
              protocols = map(object(
                {
                  type = string
                  port = number
                }
              ))
            }
          ))
        }
      ))
      network_rule_collections = list(object(
        {
          name     = string
          priority = number
          action   = string
          rules = list(object(
            {
              name                            = string
              description                     = string
              source_addresses                = optional(list(string))
              source_ip_group_references      = optional(list(string))
              destination_addresses           = optional(list(string))
              destination_fqdns               = optional(list(string))
              destination_ip_group_references = optional(list(string))
              protocols                       = list(string)
              destination_ports               = list(string)
            }
          ))
        }
      ))
    }
  ))
  default     = []
  description = "Base rule collection groups to deploy"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
