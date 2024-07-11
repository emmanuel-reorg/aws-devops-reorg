terraform {

  backend "s3" {
    bucket         = "<S3_BUCKET>"
    key            = "<KEY>"
    region         = "<REGION>"
    encrypt        = true
    dynamodb_table = "<DYNAMODB_TABLE>"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }

  required_version = ">= 1.3.0"
}