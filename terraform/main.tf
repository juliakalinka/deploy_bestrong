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

resource "azurerm_service_plan" "first-plan" {
  name                = "first-plan"
  resource_group_name = azurerm_resource_group.main_rsg.name
  location            = azurerm_resource_group.main_rsg.location
  os_type = "Linux"
  sku_name            = "B1"
  
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

resource "azurerm_linux_web_app" "bestrongdot-net-app" {
  name                = "bestrongdot-net-app"
  location            = azurerm_resource_group.main_rsg.location
  resource_group_name = azurerm_resource_group.main_rsg.name
  service_plan_id     = azurerm_service_plan.first-plan.id
  

  site_config {
    always_on        = true

    application_stack {
      docker_image_name = "bestrongexample/jdemehw:latest"
      docker_registry_url = "https://bestrongexample.azurecr.io"
      docker_registry_username = var.acr_username
      docker_registry_password = var.acr_password

    }
  }

}
