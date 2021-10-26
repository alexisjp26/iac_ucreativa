variable "environment" {
  type = string
  default = "dev"
}
variable "linux-password" {
  type = string 
  sensitive = true
  validation {
    condition = length(var.linux-password) > 8
    error_message = "Password muy corto."
    }
}
variable "linux-user" {
  type = string 
  sensitive = true
  default   = "root"
}

variable "cantidad-servers" {
  type = number
  validation {
    condition     = var.cantidad-servers <= 2
    error_message = "No se puede crear mas de 2."
  }
}

output "ip-publica" {
  value = azurerm_public_ip.publicip.*.ip_address
}

output "resource-group-name" {
  value = azurerm_resource_group.alexis.name
}

output "location" {
  value = azurerm_resource_group.alexis.location
} 