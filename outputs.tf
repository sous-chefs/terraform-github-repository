output "cookbooks" {
  value = [for x in var.repository : x.name if x.repo_type == "cookbook"]
}

output "terraform" {
  value = [for x in var.repository : x.name if x.repo_type == "terraform"]
}

output "ide" {
  value = [for x in var.repository : x.name if x.repo_type == "ide"]
}
