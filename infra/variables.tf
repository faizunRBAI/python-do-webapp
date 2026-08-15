variable "project_name" {
  type        = string
  description = "Project name used as resource prefix."
}

variable "region" {
  type        = string
  description = "DigitalOcean region slug."
  default     = "sfo3"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key material (injected by platform)."
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "PostgreSQL application user password."
  sensitive   = true
}

variable "droplet_size" {
  type        = string
  description = "Droplet size slug."
  default     = "s-1vcpu-1gb"
}

variable "do_token" {
  type        = string
  description = "DigitalOcean API token."
  sensitive   = true
  default     = ""
}
