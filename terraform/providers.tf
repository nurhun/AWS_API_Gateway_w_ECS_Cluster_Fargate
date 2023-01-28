# --- root/providers.tf ---

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.51.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.3.0"
    }
  }
}

# Configure the AWS Provider. Shared credentials file configured wth awscli conf file.
provider "aws" {
  region                   = var.REGION
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = "default"
}


provider "local" {
  # Configuration options
}