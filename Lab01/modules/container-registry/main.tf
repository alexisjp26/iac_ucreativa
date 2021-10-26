resource "azurerm_container_registry" "registry" {
    name = "${var.name}"
    resource_group_name = "${var.resource-group}"
    location = "${var.location}"
    sku = "Standard"
    admin_enabled = false  
}