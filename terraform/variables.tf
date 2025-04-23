variable "resource_group_name" {
  default = "main-resources"
}

variable "app_service_plan_tier" {
  default = "Standard"
}

variable "app_service_plan_size" {
  default = "S1"
}

variable "location" {
  description = "Azure region"
  default     = "westeurope"
}

variable "acr_username" {}
variable "acr_password" {}