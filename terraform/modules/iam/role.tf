# --- iam/role.tf ---

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

