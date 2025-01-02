provider "aws" {
  region = var.infra_region
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name] # Specify the Name tag of the peer VPC
  }
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = data.aws_vpc.main.cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  vpc_name = var.vpc_name
}

module "ec2" {
  source       = "./modules/ec2"
  ami_id       = var.ami_id
  instance_type = var.instance_type
  subnet_id    = module.vpc.public_subnet_ids[0]
  vpc_id       = module.vpc.vpc_id
  key_name     = var.key_name
  min_no_of_instances = var.min_no_of_instances
  max_no_of_instances = var.max_no_of_instances
  desired_no_of_instances = var.desired_no_of_instances
  public_subnet_ids = module.vpc.public_subnet_ids
  threshold = var.threshold
}

module "rds" {
  source              = "./modules/rds_mysql"
  #allocated_storage   = 20
  db_instance_class      = var.db_instance_class
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  #private_subnet_ids  = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.vpc_id
  ec2_sg_id           = module.ec2.ec2_sg_id
  subnet_ids  = module.vpc.private_subnet_ids
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

