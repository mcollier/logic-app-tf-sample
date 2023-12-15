variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Specifies the tier to use for this storage account."
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Specifies the kind to use for this storage account."
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Specifies the type of replication to use for this storage account."
}

variable "account_name" {
  type        = string
  description = " Specifies the name of the storage account."
}
