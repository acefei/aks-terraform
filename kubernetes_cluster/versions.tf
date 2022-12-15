terraform {
  required_version = ">= 0.13.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.15.1"
    }
  }

  backend "azurerm" {}
}
