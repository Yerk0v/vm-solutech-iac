# Se definen las variables

variable "location" {
    type = string
    description = "Azure location"
    default = "eastus2"
}

variable "prefix" {
    type = string
    default = "yerko"
}

variable "ssh-source-address" {
    type = string
    default = "Source Address"
}

variable "resource-group-name" {
    type = string
    default = "VM-Solutech"
}
