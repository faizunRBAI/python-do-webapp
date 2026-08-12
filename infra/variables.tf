variable "project_name" {
  description = "Branch-scoped project name used as a resource prefix"
  type        = string
}

variable "region" {
  description = "DigitalOcean region slug"
  type        = string
  default     = "nyc1"
}

variable "droplet_size" {
  description = "Droplet size slug"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "ssh_public_key" {
  description = "SSH public key injected by the platform at deploy time"
  type        = string
  sensitive   = true
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}
