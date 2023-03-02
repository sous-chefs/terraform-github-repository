module "repository" {
  for_each                  = { for repo in var.repository : repo.name => repo }
  source                    = "./modules/repository"
  name                      = each.value.name
  repo_type                 = each.value.repo_type
  supermarket_name_override = each.value.supermarket_name_override
  description_override      = each.value.description_override
  homepage_url_override     = each.value.homepage_url_override
  additional_topics         = each.value.additional_topics
  additional_status_checks  = each.value.additional_status_checks
  projects_enabled          = each.value.projects_enabled
  discussions_enabled       = each.value.discussions_enabled
}
