variable "repository" {
  type = list(object({
    name                      = string
    repo_type                 = string
    supermarket_name_override = optional(string)
    description_override      = optional(string)
    homepage_url_override     = optional(string)
    additional_topics         = optional(list(string)),
    additional_status_checks  = optional(list(string))
    projects_enabled          = optional(bool)
  }))
  description = "The repositories to create."
}
