variable "allocated_storage" {
  description = "RDS storage size"
  type        = number
  default     = 20
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the RDS instance"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the RDS instance"
  type        = string
}

variable "ec2_sg_id" {
  description = "Security group ID of the EC2 instance"
  type        = string
}
