terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0" 
    }
  }
}


provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  client_id = var.client_id
  client_secret = var.client_secret
}

resource "azurerm_resource_group" "main_rsg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_app_service_plan" "first-plan" {
  name                = "first-plan"
  resource_group_name = azurerm_resource_group.main_rsg.name
  location            = azurerm_resource_group.main_rsg.location

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }
}

resource "azurerm_virtual_network" "first-vnet" {
  name                = "first-vnet"
  resource_group_name = azurerm_resource_group.main_rsg.name
  location            = azurerm_resource_group.main_rsg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default-subnet" {
  name                 = "default-subnet"
  resource_group_name  = azurerm_resource_group.main_rsg.name
  virtual_network_name = azurerm_virtual_network.first-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
}

resource "azurerm_linux_web_app" "dot-net-app" {
  name                = "dot-net-app"
  location            = azurerm_resource_group.main_rsg.location
  resource_group_name = azurerm_resource_group.main_rsg.name
  service_plan_id     = azurerm_app_service_plan.first-plan.id

  site_config {
    always_on        = true
    application_stack {
      docker_image_name = "bestrongexample/jdemehw:latest"
      docker_registry_url = "https://bestrongexample.azurecr.io"

    }
  }

}
