# # --- ci/variables.tf ---

variable "ci_pipeline_name" {
  type        = string
  description = "ci pipelinne name"
}

variable "ci_project_visibility" {
  type        = string
  description = "Specifies the visibility of the project's builds. Possible values are: PUBLIC_READ and PRIVATE. Default value is PRIVATE."
  default     = "PRIVATE"
}

variable "ci_build_timeout" {
  type        = string
  description = "Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. The default is 60 minutes."
}

variable "ci_queued_timeout" {
  type        = string
  description = "(Optional) Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours."
}

variable "ci_cache_type" {
  type        = string
  description = "Type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO_CACHE, LOCAL, S3. Defaults to NO_CACHE."
}

# variable "ci_cache_location" {
#   type        = string
#   description = "(Required when cache type is S3) Location where the AWS CodeBuild project stores cached resources. For type S3, the value must be a valid S3 bucket name/prefix."
# }

# variable "ci_cache_modes" {
#   type        = string
#   description = " (Required when cache type is LOCAL) Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: LOCAL_SOURCE_CACHE, LOCAL_DOCKER_LAYER_CACHE, LOCAL_CUSTOM_CACHE."
# }

# variable "ci_concurrent_build_limit" {
#   type        = string
#   description = <<-EOT
#   AWS supports the execution of concurrent and coordinated builds of a project with “Batch” builds. "
#   Specify a maximum number of concurrent builds for the project.
#   The value specified must be greater than 0 and less than the account concurrent running builds limit.
#   EOT
#   default     = "0"
# }

variable "ci_badge_enabled" {
  type        = bool
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled."
  default     = false
}

variable "ci_service_role" {
  type        = string
  description = "ci CodeBuild Service Role"
}

variable "ci_artifacts_type" {
  type        = string
  description = "(Required) Build output artifact's type. Valid values: CODEPIPELINE, NO_ARTIFACTS, S3."
}

variable "ci_artifacts_override_artifact_name" {
  type        = bool
  description = "Whether a name specified in the build specification overrides the artifact name."
  default     = false
}

variable "ci_artifacts_encryption_disabled" {
  type        = bool
  description = "Whether to disable encrypting output artifacts. If type is set to NO_ARTIFACTS, this value is ignored. Defaults to false."
  default     = false
}

variable "ci_environment_compute_type" {
  type        = string
  description = "(Required) Information about the compute resources the build project will use. Valid values: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE. BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER. When type is set to LINUX_GPU_CONTAINER, compute_type must be BUILD_GENERAL1_LARGE."
}

variable "ci_environment_type" {
  type        = string
  description = "(Required) Type of build environment to use for related builds. Valid values: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER (deprecated), WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER."
}

variable "ci_environment_image" {
  type        = string
  description = <<-EOT
  (Required) Docker image to use for this build project. 
  Valid values include Docker images provided by CodeBuild (e.g aws/codebuild/standard:2.0), 
  Docker Hub images (e.g., hashicorp/terraform:latest), 
  and full Docker repository URIs such as those for ECR (e.g., 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest)."
  EOT
}

variable "ci_environment_image_pull_credentials_type" {
  type        = string
  description = "(Optional) Type of credentials AWS CodeBuild uses to pull images in your build. Valid values: CODEBUILD, SERVICE_ROLE. When you use a cross-account or private registry image, you must use SERVICE_ROLE credentials. When you use an AWS CodeBuild curated image, you must use CodeBuild credentials. Defaults to CODEBUILD."
}

variable "ci_environment_privileged_mode" {
  type        = bool
  description = "(Optional) Whether to enable running the Docker daemon inside a Docker container. Defaults to false."
}

variable "ci_cloudwatch_logs_status" {
  type        = string
  description = "(Optional) Current status of logs in CloudWatch Logs for a build project. Valid values: ENABLED, DISABLED. Defaults to ENABLED."
}

variable "ci_source_version" {
  type        = string
  description = "Version of the build input to be built for this project. If not specified, the latest version is used."
}

variable "ci_source_git_clone_depth" {
  type        = string
  description = "(Optional) Truncate git history to this many commits. Use 0 for a Full checkout which you need to run commands like git branch --show-current"
  default     = "1"
}

variable "ci_source_git_submodules_config" {
  type        = bool
  description = "(Required) Whether to fetch Git submodules for the AWS CodeBuild build project."
  default     = false
}

variable "ci_source_insecure_ssl" {
  type        = bool
  description = "(Optional) Ignore SSL warnings when connecting to source control."
  default     = false
}

variable "ci_source_location" {
  type        = string
  description = "(Optional) Location of the source code from git or s3."
}

variable "ci_source_report_build_status" {
  type        = bool
  description = "(Optional) Whether to report the status of a build's start and finish to your source provider. This option is only valid when the type is BITBUCKET or GITHUB."
}

variable "ci_source_type" {
  type        = string
  description = "(Required) Type of repository that contains the source code to be built. Valid values: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET, S3, NO_SOURCE."
}

variable "ci_webhook_build_type" {
  type        = string
  description = "(Optional) The type of build this webhook will trigger. Valid values for this parameter are: BUILD, BUILD_BATCH."
  default     = "BUILD"
}

variable "ci_webhook_filter01_type" {
  type        = string
  description = " (Required) The webhook filter group's type. Valid values for this parameter are: EVENT, BASE_REF, HEAD_REF, ACTOR_ACCOUNT_ID, FILE_PATH, COMMIT_MESSAGE. At least one filter group must specify EVENT as its type."
}

variable "ci_webhook_filter01_pattern" {
  type        = string
  description = " (Required) For a filter that uses EVENT type, a comma-separated string that specifies one event: PUSH, PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED. PULL_REQUEST_MERGED works with GitHub & GitHub Enterprise only. For a filter that uses any of the other filter types, a regular expression."
}

variable "ci_webhook_filter02_type" {
  type        = string
  description = " (Required) The webhook filter group's type. Valid values for this parameter are: EVENT, BASE_REF, HEAD_REF, ACTOR_ACCOUNT_ID, FILE_PATH, COMMIT_MESSAGE. At least one filter group must specify EVENT as its type."
}

variable "ci_webhook_filter02_pattern" {
  type        = string
  description = " (Required) For a filter that uses EVENT type, a comma-separated string that specifies one event: PUSH, PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED. PULL_REQUEST_MERGED works with GitHub & GitHub Enterprise only. For a filter that uses any of the other filter types, a regular expression."
}