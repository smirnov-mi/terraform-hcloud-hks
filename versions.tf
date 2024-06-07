terraform {
  required_version = ">= 1.8.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version ">= 1.47.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version ">= 4.0.5"
    }

    ssh = {
      source  = "loafoe/ssh"
      version ">= 2.7.0"
    }
  }
}

