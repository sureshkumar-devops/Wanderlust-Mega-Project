variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0f918f7e67a3323f0"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication"
  default     = "terra-admin"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}
