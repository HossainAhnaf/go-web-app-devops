provider "azurerm" {
  features {}
  
}

variable "prefix" {
  default = "go-web-app-devops"
}
resource "azurerm_resource_group" "main" {
  name = "${var.prefix}-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }
}
