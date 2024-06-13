# provider "aws" {
#     region = "ap-southeast-1"
# }

resource "aws_s3_bucket" "terraform_state" {
    bucket = var.bucket_name

    # Prevent accidental deletion of this S3 bucket
    lifecycle {
        prevent_destroy = false
    }
}

# Enable versioning
# state files
resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
    bucket = aws_s3_bucket.terraform_state.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.terraform_state.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = var.dynamodb_table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

# terraform {
#      backend "s3" {
#         # Replace this with your bucket name!
#         bucket = "swl-terraform-up-and-running-state"
#         key = "global/s3/terraform.tfstate"
#         region = "ap-southeast-1"

#         # Replace this with your DynamoDB table name!
#         dynamodb_table = "terraform-up-and-running-locks"
#         encrypt = true
#      }
# }

# output "aws_s3_arn" {
#     value = aws_s3_bucket.terraform_state.arn
#     description = "arn of s3 bucket"
# }

# output "dynamodb_table_name" { 
#     value = aws_dynamodb_table.terraform_locks.name
#     description = "name of dynamodb table"
# }

