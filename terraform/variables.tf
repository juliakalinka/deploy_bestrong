variable "resource_group_name" {
  default = "mainresources"
}

variable "app_service_plan_tier" {
  default = "Standard"
}

variable "app_service_plan_size" {
  default = "S1"
}

variable "location" {
  description = "Azure region"
  default     = "eastus"
}


variable"subscription_id"{
}
variable "tenant_id" {
  
}
variable "client_id" {
  
}
variable "client_secret" {
  
}

variable "acr_username" {
  
}
variable "acr_password" {
  
}