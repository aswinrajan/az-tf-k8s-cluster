
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
    node_count = "${var.nodecount}"
    vm_size    = "standard_d2_v5"
    type       = "VirtualMachineScaleSets"
    os_disk_size_gb = 100
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}