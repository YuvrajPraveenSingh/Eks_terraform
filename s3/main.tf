resource "aws_s3_bucket" "terraform_state" {
    bucket = var.bucket_name
    force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encrption" {
    bucket =  aws_s3_bucket.terraform_state.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    } 
}

resource "aws_dynamodb_table" "terraform_state_lock" {
    name = var.DynamoDB_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
  
}