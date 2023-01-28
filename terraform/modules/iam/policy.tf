

resource "aws_iam_policy" "allowCodeBuildGetSecretValues" {
  description = "allow CodeBuild GetSecretValues"
  name        = "allowCodeBuildGetSecretValues"
  path        = "/"

  policy = <<POLICY
{
    "Statement": [
        {
        "Action": [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
        ],
        "Effect": "Allow",
        "Resource": [
            "arn:aws:secretsmanager:eu-north-1:521156286538:secret:GITHUB_TOKEN-Pyel3G",
            "arn:aws:secretsmanager:eu-north-1:521156286538:secret:PRIVATE_KEY-DRUe2h",
            "arn:aws:secretsmanager:eu-north-1:521156286538:secret:AWS_ACCOUNT_ID-jvHbTO",
            "arn:aws:secretsmanager:eu-north-1:521156286538:secret:AWS_DEFAULT_REGION-uv8mfM"
        ],
        "Sid": "VisualEditor0"
        },
        {
        "Action": "secretsmanager:GetRandomPassword",
        "Effect": "Allow",
        "Resource": "*",
        "Sid": "VisualEditor1"
        }
    ],
    "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_policy" "allowCodeBuildCreateLogs" {
    description = "allowCodeBuildCreateLogs-eu-north-1"
    name        = "allowCodeBuildCreateLogs-eu-north-1"
    path        = "/service-role/"

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