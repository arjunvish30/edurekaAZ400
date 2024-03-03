terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
provider "azurerm" {
        subscription_id = ""
        tenant_id       = ""
        client_id       = ""
        client_secret   = ""
  features {}
}
resource "azurerm_resource_group" "terraformrg" {
  name     = "terraformrg"
  location = "East US"
}

resource "azurerm_app_service_plan" "webappplan2399" {
  name                = "webappplan2399"
  location            = azurerm_resource_group.terraformrg.location
  resource_group_name = azurerm_resource_group.terraformrg.name
  kind                = "Windows"
  reserved            = false

  sku {
    tier = "Basic"
    size = "B1"
  }
}


resource "azurerm_app_service" "webapp2399" {
  name                = "webapp2399"
  location            = azurerm_resource_group.terraformrg.location
  resource_group_name = azurerm_resource_group.terraformrg.name
  app_service_plan_id = azurerm_app_service_plan.webappplan2399.id


  site_config {
  }

  depends_on = [azurerm_app_service_plan.webappplan2399]
}
