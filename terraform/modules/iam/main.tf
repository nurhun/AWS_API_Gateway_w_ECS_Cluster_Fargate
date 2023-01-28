# --- iam/main.tf ---

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_iam_policy_attachment" {
  name       = "ecs_task_execution_role_attachment"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ECS_Logs_Policy" {
  description = "Policy to allow ECS execution role to create logs groups"
  name        = "ECS_Logs_Policy"
  path        = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ECS_Logs_Policy_to_ecs_task_execution_role_attach" {
  policy_arn = aws_iam_policy.ECS_Logs_Policy.arn
  role       = aws_iam_role.ecs_task_execution_role.id
}



resource "aws_iam_role" "codebuild_iam_role" {
  name = var.codebuild_iam_role
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
            "Service": "codebuild.amazonaws.com"
        }
        }
    ],
    "Version": "2012-10-17"
}
POLICY
}

