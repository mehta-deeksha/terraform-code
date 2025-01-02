
# Launch Template
resource "aws_launch_template" "Webserver" {
  name          = "wordpress-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name

  network_interfaces {
    security_groups = [aws_security_group.web_server_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "Webserver" {
  name                 = "web-asg"
  vpc_zone_identifier  = var.public_subnet_ids
  launch_template {
    id      = aws_launch_template.Webserver.id
    version = "$Latest"
  }

  min_size             = var.min_no_of_instances
  max_size             = var.max_no_of_instances
  desired_capacity     = var.desired_no_of_instances
  health_check_type    = "EC2"
  health_check_grace_period = 300
  tag {
      key                 = "Name"
      value               = "web-instance"
      propagate_at_launch = true
    }
}


# Create a Target Group for the Load Balancer
resource "aws_lb_target_group" "app" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id 

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "app-target-group"
  }
}

# Create an Application Load Balancer
resource "aws_lb" "app" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id] # Security Group for ALB
  subnets            = var.public_subnet_ids      # Subnets for the ALB

  enable_deletion_protection = false

  tags = {
    Name = "app-load-balancer"
  }
}

# Create a Listener for the Load Balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Security Group for the Load Balancer
resource "aws_security_group" "lb" {
  name_prefix = "lb-sg"
  description = "Allow HTTP traffic to Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "lb-sg"
  }
}

# Attach Auto Scaling Group to the Target Group
resource "aws_autoscaling_attachment" "asg_target_group" {
  autoscaling_group_name = aws_autoscaling_group.Webserver.name
  lb_target_group_arn       = aws_lb_target_group.app.arn
}






resource "aws_security_group" "web_server_sg" {
  name        = "EC2-SG"
  description = "Allow inbound SSH and outbound access to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
  }
  # Allow HTTP (port 80) access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_cloudwatch_metric_alarm" "high_request_alarm" {
  alarm_name          = "HighRequestCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = var.threshold 
  alarm_description   = "Alarm for high number of requests per target"

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
    TargetGroup  = aws_lb_target_group.app.arn_suffix
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
  ok_actions    = [aws_autoscaling_policy.scale_in.arn]
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.Webserver.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.Webserver.name
}



output "ec2_sg_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.web_server_sg.id
}
