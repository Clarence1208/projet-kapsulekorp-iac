variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "terraform-kapsulekorp"
}

variable "distro" {
  description = "The Linux distribution to use"
  type        = string
  default     = "ubuntu"
}

variable "staging_web_count" {
  description = "Number of web servers in staging"
  type        = number
  default     = 2
}

variable "staging_db_count" {
  description = "Number of db servers in staging"
  type        = number
  default     = 1
}

variable "production_web_count" {
  description = "Number of web servers in production"
  type        = number
  default     = 3
}

variable "production_db_count" {
  description = "Number of db servers in production"
  type        = number
  default     = 1
}

variable "vault_password" {
  description = "Ansible Vault password"
  type        = string
  sensitive   = true
}
