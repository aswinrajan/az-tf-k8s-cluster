
resource "azurerm_resource_group" "mainrg" {
  name     = "${var.prefix}rg"
  location = var.location
}
resource "azurerm_kubernetes_cluster" "dev-cluster" {
  name                = "${var.prefix}-cluster"
  location            = azurerm_resource_group.mainrg.location
  resource_group_name = azurerm_resource_group.mainrg.name
  dns_prefix          = "${var.prefix}dns"


  default_node_pool {
    name            = "${var.prefix}np"
    node_count      = var.nodecount
    vm_size         = "Standard_A1_v2"
    type            = "VirtualMachineScaleSets"
    os_disk_size_gb = 35
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }  
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr"
  resource_group_name = azurerm_resource_group.mainrg.name
  location            = azurerm_resource_group.mainrg.location
  sku                 = "Standard"
  admin_enabled       = false
}



