# # --- ecr/outputs.tf ---

output "repos_ids" {
  value = { for k, v in aws_ecr_repository.repos : k => v.id }
}

output "repos_urls" {
  value = { for k, v in aws_ecr_repository.repos : k => v.repository_url }
}