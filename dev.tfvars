infra_region = "ap-southeast-1"

# vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["172.31.50.0/24","172.31.51.0/24"]
private_subnet_cidrs = ["172.31.54.0/24","172.31.55.0/24"]
availability_zones = ["ap-southeast-1a","ap-southeast-1b"]
ami_id = "ami-0995922d49dc9a17d"
instance_type = "t2.micro"
key_name = "wordpresskeypair"
db_instance_class = "db.t3.micro"
db_name = "wordpress"
db_username = "admin"
db_password = "Wordpress"
vpc_name = "NonProd"






