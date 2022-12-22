module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  # Autoscaling group
  name                      = "chirag-nodejs-asg"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [element(module.vpc.private_subnets, 0), element(module.vpc.private_subnets, 1)]
  target_group_arns         = module.alb.target_group_arns
  # Launch template
  launch_template_name        = "chirag-lt"
  launch_template_description = "Launch template for nodejs"
  update_default_version      = true
  image_id                    = "ami-07ffb56d3b5b9b779"
  instance_type               = "t3a.small"
  iam_instance_profile_name   = "chirag-role"
  ebs_optimized               = true
  enable_monitoring           = true
  key_name                    = "Chirag-Nodejs"
  security_groups             = [aws_security_group.nodejs.id]
  tags = {
    Owner = "chirag"
  }
}
resource "aws_security_group" "nodejs" {
  name   = "nodejs-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = [aws_security_group.pritunl-sg.id]
  }
  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "TCP"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "nodejs-sg"
    Owner = "chirag"
  }
}
<<<<<<< HEAD

=======
>>>>>>> 0bbd632ba2d879a3892595ca905918d6b2d6ad75
resource "aws_autoscaling_policy" "asg-policy" {
  count                     = 1
  name                      = "Chirag-asg-cpu-policy"
  autoscaling_group_name    = module.asg.autoscaling_group_name
  estimated_instance_warmup = 60
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

