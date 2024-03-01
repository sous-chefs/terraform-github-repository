terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  required_version = "~> 1.7.0"

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
