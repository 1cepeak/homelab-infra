terraform {
  required_version = "~> 1.13.2"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.86.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }

  # backend "s3" {
  #   skip_credentials_validation = true
  #   skip_region_validation      = true
  #   skip_metadata_api_check     = true
  #   skip_requesting_account_id  = true
  #   use_path_style              = true
  #   insecure                    = true
  #   bucket                      = "terraform"
  #   key                         = "state/core/terraform.tfstate"
  #   region                      = "eu-east-1"
  # }
}

provider "proxmox" {
  endpoint  = var.PROXMOX_ENDPOINT
  insecure  = true
  api_token = "${var.PROXMOX_USER}@pam!${var.PROXMOX_API_TOKEN_ID}=${var.PROXMOX_API_TOKEN_SECRET}"

  ssh {
    agent    = false
    username = var.PROXMOX_USER
    # private_key = var.PROXMOX_PRIVATE_KEY_PATH
    private_key = file(pathexpand(var.PROXMOX_PRIVATE_KEY_PATH))
  }
}

provider "random" {}

provider "null" {}

provider "local" {}

provider "tls" {}
