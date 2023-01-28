# --- iam/outputs.tf ---

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "codebuild_iam_role_arn" {
  value = aws_iam_role.codebuild_iam_role.arn
}