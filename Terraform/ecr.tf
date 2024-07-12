resource "aws_ecr_repository" "fastapi_repo" {
  name = "fastapi-repo"
}

resource "aws_ecr_repository_policy" "my_ecr_repo_policy" {
  repository = aws_ecr_repository.fastapi_repo.name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPull",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:DescribeRepositories",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ]
    }
  ]
}
EOF
}

resource "aws_ecr_repository" "lambda_schedule_repo" {
  name = "lambda-schedule"
}

resource "aws_ecr_repository_policy" "lambda_ecr_repo_policy" {
  repository = aws_ecr_repository.lambda_schedule_repo.name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPull",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:DescribeRepositories",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ]
    }
  ]
}
EOF
}