variable "resource_group_name" {}
variable "location" {}

variable "client_id" {
    sensitive = true
}
variable "client_secret" {
    sensitive = true
}