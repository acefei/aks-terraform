terraform {
  required_version = ">= 0.13.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.15.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.16.1"
    }
    helm = {
      source  = "helm"
      version = "=2.8.0"
    }
  }

  backend "azurerm" {}
}
