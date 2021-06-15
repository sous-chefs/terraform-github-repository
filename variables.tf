variable "cookbook" {
  type = list(object({
    name                      = string
    supermarket_name_override = optional(string)
  }))
  description = "The cookbook repositories to create."
}

variable "terraform" {
  type = list(object({
    name         = string
    homepage_url = optional(string)
    topics       = optional(list(string)),
  }))
  description = "The terraform repositories to create."
}

variable "ide" {
  type = list(object({
    name         = string
    homepage_url = string
    topics       = optional(list(string)),
  }))
  description = "The ide repositories to create."
}

variable "other" {
  type = list(object({
    name = string

    description  = string
    homepage_url = optional(string)
    topics       = list(string),
  }))
  description = "Other repositories to create."
}