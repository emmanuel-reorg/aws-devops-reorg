resource "aws_s3_bucket" "scheduledbucketfastapi" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "scheduledbucketfastapi"
    Environment = "dev"
  }
}

resource "aws_iam_policy" "lambda_s3_put_policy" {
  name        = "lambda_s3_put_policy"
  description = "IAM policy for allowing lambda to put objects in S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.scheduledbucketfastapi.arn}/*"
      },
    ]
  })
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.reorg.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.reorg_rt.id]
  policy          = <<POLICY
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }
  ]
}
POLICY
}