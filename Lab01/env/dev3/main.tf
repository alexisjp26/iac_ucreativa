terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "infra-control-rg"
    storage_account_name = "iacucreativa2"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

module "linux-server" {
  source           = "../../modules/servers"
  linux-password   = "${var.linux-password}"
  linux-user       = "admindev"
  environment      = "dev"
  cantidad-servers = 1
}

module "aws-ec2" {
  source = "../../modules/ec2"
  
}