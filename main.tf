module "cookbook_repository" {
  for_each                  = { for repo in var.cookbook : repo.name => repo }
  source                    = "./modules/repository"
  name                      = each.value.name
  repo_type                 = "cookbook"
  supermarket_name_override = each.value.supermarket_name_override
}

module "terraform_repository" {
  for_each     = { for repo in var.terraform : repo.name => repo }
  source       = "./modules/repository"
  name         = each.value.name
  repo_type    = "terraform"
  homepage_url = each.value.homepage_url
  topics       = each.value.topics
}

module "ide_repository" {
  for_each     = { for repo in var.ide : repo.name => repo }
  source       = "./modules/repository"
  name         = each.value.name
  repo_type    = "ide"
  homepage_url = each.value.homepage_url
  topics       = each.value.topics
}

module "other_repository" {
  for_each     = { for repo in var.other : repo.name => repo }
  source       = "./modules/repository"
  name         = each.value.name
  repo_type    = "other"
  description  = each.value.description
  homepage_url = each.value.homepage_url
  topics       = each.value.topics
}

