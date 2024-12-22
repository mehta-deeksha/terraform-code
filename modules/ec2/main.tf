resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "EC2-Instance"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "EC2-SG"
  description = "Allow inbound SSH and outbound access to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_instance_id" {
  value = aws_instance.ec2_instance.id
}

output "ec2_sg_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}
