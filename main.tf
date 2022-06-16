terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "aswin-rajan"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "az-tf-k8s-dev-app"
    }
  }
}

resource "azurerm_resource_group" "mainrg" {
  name     = "${var.prefix}-resources"
  location = var.location
}