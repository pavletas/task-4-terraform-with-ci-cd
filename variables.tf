variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group"
}

variable "app_service_plan_name" {
  type        = string
  description = "The name of the app service plan"
}

variable "app_service_name" {
  type        = string
  description = "The name of the app service"
}

variable "sql_server_name" {
  type        = string
  description = "The name of the sql server"
}

variable "sql_database_name" {
  type        = string
  description = "The name of the sql database"
}

variable "sql_user" {
  type        = string
  description = "SQL user"
}

variable "sql_user_pass" {
  type        = string
  description = "The pass for the sql user"
}

variable "firewall_rule_name" {
  type        = string
  description = "The name of the firewall rull"
}

variable "github_repo" {
  type        = string
  description = "The url of the github repo"
}