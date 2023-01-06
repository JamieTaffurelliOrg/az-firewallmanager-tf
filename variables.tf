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
  description = "Base firewall policy to deploy"
}

variable "intrusion_detection_mode" {
  type        = string
  default     = "Deny"
  description = "Intrustion detection mode, Off, Alert or Deny"
}

variable "base_policy_rule_collection_groups" {
  type = list(object(
    {
      name     = string
      priority = number
      application_rule_collections = list(object(
        {
          name                       = string
          description                = string
          action                     = string
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
      network_rule_collections = list(object(
        {
          name                            = string
          description                     = string
          action                          = string
          source_addresses                = optional(list(string))
          source_ip_group_references      = optional(list(string))
          destination_addresses           = optional(list(string))
          destination_fqdns               = optional(list(string))
          destination_ip_group_references = optional(list(string))
          protocols                       = optional(list(string))
          destination_ports               = optional(list(string))
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
