data "azurerm_client_config" "current" {}

module "conditional_access" {
  source   = "github.com/navonron/terraform_az_ca//modules/conditional_access"
  policies = var.policies
}
