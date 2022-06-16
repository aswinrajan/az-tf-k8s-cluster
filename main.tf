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
    organization = "aswinrajan"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "az-tf-k8s-dev-app"
    }
  }
}

resource "azurerm_resource_group" "mainrg" {
  name     = "${var.prefix}resources"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "dev-cluster" {
  name                = "${var.prefix}cluster"
  location            = azurerm_resource_group.mainrg.location
  resource_group_name = azurerm_resource_group.mainrg.name
  dns_prefix          = "${var.prefix}dns"

  default_node_pool {
    name       = "${var.prefix}np"
    node_count = 1
    vm_size    = "standard_d2_v5"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}