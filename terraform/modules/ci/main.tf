# # --- ci/main.tf ---

resource "aws_codebuild_project" "Build_Deploy_Pipeline" {
  name               = var.ci_pipeline_name
  project_visibility = var.ci_project_visibility
  build_timeout      = var.ci_build_timeout
  queued_timeout     = var.ci_queued_timeout
  service_role       = var.ci_service_role

  badge_enabled = var.ci_badge_enabled

  #   concurrent_build_limit = var.ci_concurrent_build_limit
  #   encryption_key         = "arn:aws:kms:eu-north-1:521156286538:alias/aws/s3"

  # Check cache option
  # https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectCache.html
  cache {
    type = var.ci_cache_type
  }

  artifacts {
    type                   = var.ci_artifacts_type
    override_artifact_name = var.ci_artifacts_override_artifact_name
    encryption_disabled    = var.ci_artifacts_encryption_disabled
  }

  environment {
    type                        = var.ci_environment_type
    compute_type                = var.ci_environment_compute_type
    image                       = var.ci_environment_image
    image_pull_credentials_type = var.ci_environment_image_pull_credentials_type
    privileged_mode             = var.ci_environment_privileged_mode
  }

  logs_config {
    cloudwatch_logs {
      status = var.ci_cloudwatch_logs_status
    }
  }

  source_version = var.ci_source_version
  source {
    git_clone_depth = var.ci_source_git_clone_depth

    git_submodules_config {
      fetch_submodules = var.ci_source_git_submodules_config
    }

    insecure_ssl        = var.ci_source_insecure_ssl
    location            = var.ci_source_location
    report_build_status = var.ci_source_report_build_status
    # report_build_status = "false"
    type = "GITHUB"
    # type                = "GITHUB"
  }

}
# terraform import module.ci.aws_codebuild_project.Build_Deploy_Pipeline KetoValutBuild


resource "aws_codebuild_webhook" "Build_Deploy_Pipeline_webhook" {
  project_name = aws_codebuild_project.Build_Deploy_Pipeline.name
  build_type   = var.ci_webhook_build_type
  filter_group {
    filter {
      type                    = var.ci_webhook_filter01_type
      pattern                 = var.ci_webhook_filter01_pattern
      exclude_matched_pattern = "false"
    }

    filter {
      type                    = var.ci_webhook_filter02_type
      pattern                 = var.ci_webhook_filter02_pattern
      exclude_matched_pattern = "false"
    }

  }
}
# terraform import module.ci.aws_codebuild_webhook.Build_Deploy_Pipeline_webhook KetoValutBuild