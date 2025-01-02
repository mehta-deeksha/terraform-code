variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "key_name" {
  description = "Key pair name for the EC2 instance"
  type        = string
}

variable "min_no_of_instances"{
  description = "Minimum number of instances needed"
  type        = string
}

variable "max_no_of_instances"{
  description = "Maximum number of instances needed"
  type        = string
}

variable "desired_no_of_instances"{
  description = "Desired number of instances "
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where the ASG instances should be launched"
  type        = list(string)
}

variable "threshold" {
  description = "No of requests threshold per server"
  type = number
}
