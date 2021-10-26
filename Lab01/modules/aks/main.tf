locals {
  prefix = "iac${terraform.workspace == "default" ? "dev1" : terraform.workspace}"
}

resource "azurerm_kubernetes_cluster" "aks" {
    name = "${local.prefix}aks"
    location = var.location
    resource_group_name = var.resource_group_name
    node_resource_group = "${var.resource_group_name}-managed"
    dns_prefix = "iacucreativaclase04"

    default_node_pool {
      name = "pool01"
      node_count = 1
      vm_size = "Standard_D2_v2"
    } 

    service_principal {
      client_id = var.client_id
      client_secret = var.client_secret
    }


} 