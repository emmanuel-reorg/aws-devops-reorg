variable "s3_bucket_backend" {
  description = "S3 bucket terraform backend"
  type        = string
  default     = "reorg-terraformstate"

}

variable "lambda_name" {
  description = "Lambda function name"
  type        = string
  default     = "scheduledbucketfastapi"

}
variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "scheduledbucketfastapi"

}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"

}