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

variable "DB_ADMIN_LOGIN" {
  default = ""
}
variable "DB_ADMIN_PASSWORD" {
  default = ""
}

variable "key" {
  default = ""
}

variable "container_apps" {
  type = list(object({
    name            = string
    image           = string
    tag             = string
    containerPort   = number
    ingress_enabled = bool
    min_replicas    = number
    max_replicas    = number
    cpu_requests    = number
    mem_requests    = string
  }))

  default = [{
    image           = "cloudleaguecr.azurecr.io/node-app"
    name            = "cloud-league-app"
    tag             = "latest"
    containerPort   = 8080
    ingress_enabled = true
    min_replicas    = 3
    max_replicas    = 5
    cpu_requests    = 0.5
    mem_requests    = "1.0Gi"
    }]

}