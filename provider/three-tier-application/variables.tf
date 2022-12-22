variable "location" {
  type    = string
  default = "East US"
}

variable "resourceGroup" {
  type    = string
  default = "cloudLeagueResourceGroup"
}

variable "subnet-id" {
  type    = string
  default = ""
}

variable "virtual-network-id" {
  type    = string
  default = ""
}

variable "container-group-ip-address" {
  type    = string
  default = ""
}