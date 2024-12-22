# Declare variables for the RDS module
variable "db_instance_class" {
  type        = string
  description = "The instance class/type for the database."
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "wordpress_db"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID where the RDS instance will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "The amount of storage (in gigabytes) to allocate to the DB instance."
  type        = number
  default     = 20  # You can set a default value or pass it explicitly
}

variable "ec2_sg_id" {
  type        = string
  description = "The security group ID of the EC2 instance to allow access to RDS."
}