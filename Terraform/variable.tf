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

variable "domain_name" {
  description = "AWS region"
  type        = string
  default     = "alvarez-ops.com"

}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"

}

variable "api_name" {
  description = "API name"
  type        = string
  default     = "fastapi"

}

