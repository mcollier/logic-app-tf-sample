variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "logic_app_name" {
  description = ""
  type        = string
}

variable "app_service_plan_id" {
  description = ""
  type        = string
}

variable "storage_account_name" {
  description = ""
  type        = string
}

variable "storage_account_access_key" {
  description = ""
  type        = string
}

variable "app_insights_connection_string" {
  description = ""
  type        = string

}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "app_settings" {
  description = "A map of app settings."
  type        = map(string)
  default     = {}
}
