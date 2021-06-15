variable "name" {}

variable "supermarket_name_override" {
  default = ""
}

variable "repo_type" {
  type = string
  validation {
    condition     = can(regex("^cookbook|terraform|ide|other$", var.repo_type))
    error_message = "The repo_type must be cookbook, terraform, ide or other. Case Sensitive."
  }
}
variable "description" {
  type    = string
  default = ""
}
variable "homepage_url" {
  type    = string
  default = ""
}
variable "topics" {
  type    = list(string)
  default = []
}

locals {
  // supermarket_name
  supermarket_name = var.supermarket_name_override == null ? var.name : var.supermarket_name_override
}

locals {
  // topics only
  default_topics = ["terraform-managed"]

  chef_topics       = var.repo_type == "cookbook" ? ["chef", "chef-cookbook", "chef-resource", "${replace(replace(local.supermarket_name, "_", "-"), ".", "")}", "hacktoberfest"] : []
  ide_topics        = var.repo_type == "ide" ? ["ide", "${replace(replace(var.name, "_", "-"), ".", "")}"] : []
  terraform_topics  = var.repo_type == "terraform" ? ["terraform", "${replace(replace(var.name, "_", "-"), ".", "")}"] : []
  additional_topics = var.repo_type != "cookbook" && var.topics != null ? var.topics : []
  topics            = concat(local.default_topics, local.chef_topics, local.ide_topics, local.terraform_topics, local.additional_topics)
}

locals {
  // description only
  chef_description      = var.repo_type == "cookbook" ? "Development repository for the ${local.supermarket_name} cookbook" : ""
  ide_description       = var.repo_type == "ide" ? "Development repository for the ${var.name} ide plugin" : ""
  terraform_description = var.repo_type == "terraform" ? "Configuration repository for the ${var.name} terraform code" : ""
  other_description     = var.repo_type == "other" ? var.description : ""
  description           = join("", [local.chef_description, local.ide_description, local.terraform_description, local.other_description])
}

locals {
  // homepage_url
  chef_homepage_url    = var.repo_type == "cookbook" ? "https://supermarket.chef.io/cookbooks/${local.supermarket_name}" : ""
  default_homepage_url = var.homepage_url == null ? "" : var.homepage_url
  homepage_url         = join("", [local.chef_homepage_url, local.default_homepage_url])
}
