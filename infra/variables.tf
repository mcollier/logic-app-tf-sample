# Input variables for the module

variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "resource_group_name" {
  description = ""
  type        = string
}

variable "log_analytics_workspace_name" {
  description = ""
  type        = string
}

variable "application_insights_name" {
  description = ""
  type        = string
}

variable "logic_app_storage_account_name" {
  description = ""
  type        = string
}

variable "notification_storage_account_name" {
  description = ""
  type        = string
}

variable "notification_queue_name" {
  description = ""
  type        = string
  default     = "my-notifications-queue"
}

variable "logic_app_plan_name" {
  description = ""
  type        = string
}

variable "logic_app_name" {
  description = ""
  type        = string
}
