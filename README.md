This code contains main.tf, dev.tfvars, variables.tf and 3 modules vpc, ec2 and rds_mysql

vpc module will create public subnet, private subnet, internet gateway, public route table

ec2 module will create a launch template, auto scaling group, target group for load balancer, application load balancer, security groups, cloud watch alarm for auto scaling policy

rds_mysql module will create rds my sql db 

main.tf under terraform code will call the modules and creates the resources.

dev.tfvars comtains variables related to dev environment like region. instance type, availability zone
