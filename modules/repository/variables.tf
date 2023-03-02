variable "name" {
  type = string
}

variable "supermarket_name_override" {
  default = ""
  type    = string
}

variable "projects_enabled" {
  type    = bool
  default = false
}

variable "repo_type" {
  type = string
  validation {
    condition     = can(regex("^cookbook|terraform|ide|other$", var.repo_type))
    error_message = "The repo_type must be cookbook, terraform, ide or other. Case sensitive."
  }
}

variable "description_override" {
  type    = string
  default = ""
}

variable "homepage_url_override" {
  type    = string
  default = ""
}

variable "additional_topics" {
  type    = list(string)
  default = []
}

variable "additional_status_checks" {
  type    = list(string)
  default = []
}

variable "discussions_enabled" {
  type    = bool
  default = false
}

locals {
  // supermarket_name
  supermarket_name = var.supermarket_name_override == null ? var.name : var.supermarket_name_override

  // status checks only
  chef_status_checks       = var.repo_type == "cookbook" ? ["lint-unit / mdl", "lint-unit / yamllint", "lint-unit / cookstyle", "Changelog Validator", "Metadata Version Validator", "Release Label Validator"] : []
  terraform_status_checks  = var.repo_type == "terraform" ? ["mdl", "yamllint", "json", "terraform-lint", "Terraform Cloud/sous-chefs/${var.name}"] : []
  additional_status_checks = var.additional_status_checks != null ? var.additional_status_checks : []
  status_checks            = distinct(compact(concat(local.chef_status_checks, local.terraform_status_checks, local.additional_status_checks)))

  // topics only
  default_topics = ["managed-by-terraform"]

  chef_topics       = var.repo_type == "cookbook" ? ["chef", "chef-cookbook", "chef-resource", "${replace(replace(local.supermarket_name, "_", "-"), ".", "")}", "hacktoberfest"] : []
  ide_topics        = var.repo_type == "ide" ? ["ide", "${replace(replace(var.name, "_", "-"), ".", "")}"] : []
  terraform_topics  = var.repo_type == "terraform" ? ["terraform", "${replace(replace(var.name, "_", "-"), ".", "")}"] : []
  additional_topics = var.additional_topics != null ? var.additional_topics : []
  topics            = distinct(compact(concat(local.default_topics, local.chef_topics, local.ide_topics, local.terraform_topics, local.additional_topics)))

  // description only
  chef_description      = var.repo_type == "cookbook" ? "Development repository for the ${local.supermarket_name} cookbook" : ""
  ide_description       = var.repo_type == "ide" ? "Development repository for the ${var.name} ide plugin" : ""
  terraform_description = var.repo_type == "terraform" ? "Configuration repository for the ${var.name} terraform code" : ""
  description           = var.description_override != null ? var.description_override : join("", [local.chef_description, local.ide_description, local.terraform_description])

  // homepage_url
  chef_homepage_url = var.repo_type == "cookbook" ? "https://supermarket.chef.io/cookbooks/${local.supermarket_name}" : ""
  homepage_url      = var.homepage_url_override != null ? var.homepage_url_override : local.chef_homepage_url
}
