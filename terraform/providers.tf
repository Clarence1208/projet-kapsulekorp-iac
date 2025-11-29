terraform {
  required_providers {
    orbstack = {
      source  = "local/orbstack"
      version = "1.0.0"
    }
  }
}

provider "orbstack" {}
