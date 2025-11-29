terraform {
  required_providers {
    orbstack = {
      source  = "local/orbstack"
      version = "1.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "orbstack" {}
