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
variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "The CIDR block for the VPC" 
}

variable "availability_zone1" {
    type = string
    default = "us-east-1a"
    description = "The availability zone for the subnet"
}
variable "availability_zone2" {
    type = string
    default = "us-east-1b"
    description = "The availability zone for the subnet"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
    description = "The instance type to launch"
  
}