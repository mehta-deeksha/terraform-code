variable "infra_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}


variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Key pair name for the EC2 instance"
  type        = string
}


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
