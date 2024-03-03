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

# Define variables
variable "location" {
  default = "East US"
}

variable "tags" {
  default = {
    environment = "development"
    project     = "myproject"
  }
}

variable "admin_username" {
  default = "adminuser"
}

variable "admin_password" {
  default = "P@ssw0rd123!"
}

variable "vm_size" {
  default = "Standard_DS1_v2"
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "caf-rg"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "caf-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "caf-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# SQL Server
resource "azurerm_sql_server" "sql" {
  name                         = "caf-sql"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  tags                         = var.tags
}

# App Service Plan
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "caf-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Windows"
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Web App
resource "azurerm_app_service" "webapp" {
  name                = "caf-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  tags                = var.tags
}
