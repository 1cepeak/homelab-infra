# Proxmox

variable "PROXMOX_ENDPOINT" {
  type        = string
  description = "Proxmox VE endpoint URL"
  sensitive   = true
}

variable "PROXMOX_USER" {
  type        = string
  description = "Proxmox VE PAM user without realm"
  default     = "terraform"
}

variable "PROXMOX_API_TOKEN_ID" {
  type        = string
  description = "Proxmox VE API token ID"
  sensitive   = true
}

variable "PROXMOX_API_TOKEN_SECRET" {
  type        = string
  description = "Proxmox VE API token secret"
  sensitive   = true
}

variable "PROXMOX_NODE" {
  type        = string
  description = "Proxmox VE node name"
  default     = "pve"
}

variable "PROXMOX_PRIVATE_KEY_PATH" {
  type        = string
  description = "Path to the SSH private key used to access Proxmox VE"
  default     = "~/.ssh/proxmox"
}

# Minio
variable "MINIO_USER" {
  type        = string
  description = "MinIO root user"
  default     = "admin"
}

variable "MINIO_BUCKETS" {
  type        = list(string)
  description = "MinIO default buckets"
}
