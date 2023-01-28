# --- ecr/locals.tf ---

locals {
  repos = {
    api_repo = {
      name                 = var.api_repo
      image_tag_mutability = var.image_tag_mutability
      force_delete         = var.force_delete
      encryption_type      = var.encryption_type
      scan_on_push         = var.scan_on_push
    },
    frontend_repo = {
      name                 = var.frontend_repo
      image_tag_mutability = var.image_tag_mutability
      force_delete         = var.force_delete
      encryption_type      = var.encryption_type
      scan_on_push         = var.scan_on_push
    }
  }
}