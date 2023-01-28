# --- ecr/main.tf ---

resource "aws_ecr_repository" "repos" {
  for_each = local.repos
  name     = each.value.name

  image_tag_mutability = each.value.image_tag_mutability

  force_delete = each.value.force_delete

  encryption_configuration {
    encryption_type = each.value.encryption_type
  }

  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }
}
# terraform import module.ecr.aws_ecr_repository.repos[\"api_repo\"] django_rest_framework_movies_apis_w_react_frontend_backend
# terraform import module.ecr.aws_ecr_repository.repos[\"frontend_repo\"] django_rest_framework_movies_apis_w_react_frontend_nginx