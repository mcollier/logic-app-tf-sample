variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "application_insights_name" {
  description = ""
  type        = string
}

variable "log_analytics_workspace_id" {
  description = ""
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}
