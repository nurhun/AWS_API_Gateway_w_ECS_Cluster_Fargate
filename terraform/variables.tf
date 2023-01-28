# --- root/variables.tf ---

variable "REGION" {}
variable "ZONE" {}


# ### ecr ###
variable "api_repo" {
  type        = string
  description = "Backend api repo name"
}

variable "frontend_repo" {
  type        = string
  description = "Frontend repo name"
}


# ### ci ###
variable "ci_pipeline_name" {
  type        = string
  description = "ci pipelinne name"
}

variable "ci_source_location" {
  type        = string
  description = "(Optional) Location of the source code from git or s3."
}

variable "ci_source_version" {
  type        = string
  description = "Version of the build input to be built for this project. If not specified, the latest version is used."
}