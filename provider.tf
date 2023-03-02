terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.15"
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
