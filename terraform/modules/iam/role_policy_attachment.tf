# --- iam/role_policy_attachment.tf ---

resource "aws_iam_policy_attachment" "ecs_iam_policy_attachment" {
  name       = "ecs_task_execution_role_attachment"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ECS_Logs_Policy_to_ecs_task_execution_role_attach" {
  policy_arn = aws_iam_policy.ECS_Logs_Policy.arn
  role       = aws_iam_role.ecs_task_execution_role.id
}

# Get Secrets values from Secret manager
resource "aws_iam_role_policy_attachment" "SecretValues_policy_bindings" {
  policy_arn = aws_iam_policy.allowCodeBuildGetSecretValues.arn
  role       = var.codebuild_iam_role
}

# Create Logs in Cloudwatch
resource "aws_iam_role_policy_attachment" "CreateLogs_policy_bindings" {
  policy_arn = aws_iam_policy.allowCodeBuildCreateLogs.arn
  role       = var.codebuild_iam_role
}

# GetAuthorizationToken for ecr docker login
resource "aws_iam_role_policy_attachment" "GetAuthorizationToken_policy_bindings" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = var.codebuild_iam_role
}