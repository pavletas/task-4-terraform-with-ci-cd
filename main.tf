terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "azurerm" {
  subscription_id = "ea918671-32c5-42c9-aea0-9f18887a22f8"
  features {

  }
}

provider "random" {
  # Configuration options
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "pavletarg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "serviceplanrg" {
  name                = "${var.app_service_plan_name}-${random_integer.ri.result}"
  location            = azurerm_resource_group.pavletarg.location
  resource_group_name = azurerm_resource_group.pavletarg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "linuxwebapprg" {
  name                = "${var.app_service_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.pavletarg.name
  location            = azurerm_service_plan.serviceplanrg.location
  service_plan_id     = azurerm_service_plan.serviceplanrg.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.mssqlserverrgpavleta.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.mssqldatabaserg.name};User ID=${azurerm_mssql_server.mssqlserverrgpavleta.administrator_login};Password=${azurerm_mssql_server.mssqlserverrgpavleta.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "sourcecontrolrg" {
  app_id                 = azurerm_linux_web_app.linuxwebapprg.id
  repo_url               = var.github_repo
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_mssql_server" "mssqlserverrgpavleta" {
  name                         = "${var.sql_server_name}-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.pavletarg.name
  location                     = azurerm_resource_group.pavletarg.location
  version                      = "12.0"
  administrator_login          = var.sql_user
  administrator_login_password = var.sql_user_pass
}

resource "azurerm_mssql_database" "mssqldatabaserg" {
  name           = "${var.sql_database_name}-${random_integer.ri.result}"
  server_id      = azurerm_mssql_server.mssqlserverrgpavleta.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "mssqlfirewallrulerg" {
  name             = "${var.firewall_rule_name}-${random_integer.ri.result}"
  server_id        = azurerm_mssql_server.mssqlserverrgpavleta.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}