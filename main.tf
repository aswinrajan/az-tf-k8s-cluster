terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
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

module "cluster" {
  source = "./modules/cluster"
}

module "k8s-apps" {
  source                 = "./modules/k8s-deployment"
  host                   = module.cluster.host
  client_certificate     = base64decode(module.cluster.client_certificate)
  client_key             = base64decode(module.cluster.client_key)
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
}