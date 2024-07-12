resource "aws_lambda_function" "scheduled_lambda" {
  function_name = "scheduled_lambda"
  handler       = "handler.lambda_handler"
  runtime       = "provided.al2"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "891377034703.dkr.ecr.us-east-1.amazonaws.com/lambda-schedule:latest"
  package_type  = "Image"

  vpc_config {
    subnet_ids         = [aws_subnet.subnet-1a.id]
    security_group_ids = [aws_security_group.reorg_default_sg.id]
  }
  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.scheduledbucketfastapi.bucket
    }
  }
  depends_on = [aws_vpc.reorg]
  lifecycle {
    ignore_changes = [
      image_uri,
      handler,
      runtime,
    ]
  
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_vpc_access_policy" {
  name        = "lambda_vpc_access_policy"
  description = "IAM policy for Lambda VPC access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
        ],
        Resource = "*",
        Effect   = "Allow",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_put_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_s3_put_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_cloudwatch_event_rule" "every_hour_trigger" {
  name                = "every-hour-trigger"
  description         = "Trigger Lambda every hour"
  schedule_expression = "cron(0 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.every_hour_trigger.name
  target_id = "invokeScheduledLambda"
  arn       = aws_lambda_function.scheduled_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge_to_call_scheduled_lambda" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduled_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_hour_trigger.arn
  depends_on = [ aws_lambda_function.scheduled_lambda ]
}

resource "aws_iam_role" "lambda_invoke_role" {
  name = "lambda_invoke_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com",
        },
      },
    ],
  })
}