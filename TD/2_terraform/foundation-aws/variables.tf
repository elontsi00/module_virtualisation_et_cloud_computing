variable "region" {
  type        = string
  description = "Région AWS"
  default     = "eu-west-3"
}

variable "availability_zones" {
  type        = list(string)
  description = "Zones de disponibilité dans la région"
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "vm_count" {
  type        = number
  description = "Nombre d'instances EC2 (haute disponibilité)"
  default     = 2
}

variable "dns_domain" {
  type        = string
  description = "Nom de domaine Route 53"
  default     = "kiowy.com"
}