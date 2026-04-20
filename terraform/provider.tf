provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = ">= 1.14.0"

  cloud {
    organization = "za4emyavam"
    
    workspaces {
      name = "portfolio"
    }
  }
}
