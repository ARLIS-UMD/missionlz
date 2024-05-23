# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "resource_group_name" {
  description = "The name of the resource group the virtual machine resides in"
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network the virtual machine resides in"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet the virtual machine resides in"
  type        = string
}

variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "use_ssh_key" {
  description = "Generate an SSH key instead of password"
  type        = bool
  default     = true
}

variable "size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username of the virtual machine"
  type        = string
}
/*
variable "admin_password" {
  description = "The admin password of the virtual machine"
  type        = string
  sensitive   = true
}
*/
variable "disable_pw_auth" {
  description = "Boolean to turn off password auth"
  type        = bool
}

variable "keyvault_name" {
  description = "Name of vault with admin ssh key"
  type        = string

}
variable "publisher" {
  description = "The publisher of the virtual machine source image"
  type        = string
}

variable "offer" {
  description = "The offer of the virtual machine source image"
  type        = string
}

variable "sku" {
  description = "The SKU of the virtual machine source image"
  type        = string
}

variable "image_version" {
  description = "The version of the virtual machine source image"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
  type        = map(string)
}
