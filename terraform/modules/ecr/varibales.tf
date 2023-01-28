# # --- ecr/variables.tf ---

variable "api_repo" {
  type        = string
  description = "Backend api repo name"
  # default = ""
}

variable "frontend_repo" {
  type        = string
  description = "Frontend repo name"
  # default = ""
}

variable "image_tag_mutability" {
  type        = string
  description = "repo image_tag_mutability. Must be one of: MUTABLE or IMMUTABLE"
  default     = "MUTABLE"
}

variable "encryption_type" {
  type        = string
  description = "repo encryption_type. Valid values are AES256 or KMS."
  default     = "AES256"
}

variable "force_delete" {
  type        = bool
  description = "repo force_delete boolean option."
  default     = false
}

variable "scan_on_push" {
  type        = bool
  description = "repo scan_on_push boolean option."
  default     = false
}