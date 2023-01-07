locals {
  deployed_ip_groups_names = [for k in azurerm_ip_group.ip_group : k.name]
}
