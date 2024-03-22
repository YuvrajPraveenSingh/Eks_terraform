variable "backend_bucket_name" {
    type = string
    default = "devops-terraform-state-2024"
    description = "The name of the S3 bucket to create"
  
}

variable "region" {
    type = string
    default = "us-east-1"
    description = "The region to create the S3 bucket in"
  
}