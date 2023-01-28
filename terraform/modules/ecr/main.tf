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