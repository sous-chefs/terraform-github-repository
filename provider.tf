terraform {
  // Enabled so we can have optionals in our objects,
  // see: https://github.com/hashicorp/terraform/issues/19898
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.13"
    }
  }
  required_version = "~> 1.3.0"

  backend "remote" {
    organization = "sous-chefs"
    workspaces {
      name = "terraform-github-repository"
    }
  }
}

provider "github" {
  owner = "sous-chefs"
}