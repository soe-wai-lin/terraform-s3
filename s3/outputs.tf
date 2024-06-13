
output "aws_s3_arn" {
    value = resource.aws_s3_bucket.terraform_state.arn
    description = "arn of s3 bucket"
}

output "dynamodb_table_name" { 
    value = resource.aws_dynamodb_table.terraform_locks.name
    description = "name of dynamodb table"
}

