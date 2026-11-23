variable "project_id" {
  type        = string
  description = "Projet GCP"
  default     = "polytech-dijon"
}

variable "region" {
  type        = string
  description = "Région GCP"
  default     = "europe-west1"
}

variable "zone" {
  type        = string
  description = "Zone GCP"
  default     = "europe-west1-b"
}

variable "access_token" {
  type        = string
  description = "Token d'accès (placeholder du TD)"
  default     = "patate"
}

variable "vm_count" {
  type        = number
  description = "Nombre de VMs pour la haute disponibilité (point 5)"
  default     = 2
}

variable "dns_domain" {
  type        = string
  description = "Domaine DNS géré (point 4)"
  default     = "kiowy.com."
}