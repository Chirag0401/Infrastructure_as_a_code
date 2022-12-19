module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one-chirag", "two-chirag", "three-chirag"])

  name = "mongo-${each.key}"

  ami                    = "ami-0530ca8899fac469f"
  instance_type          = "t3a.small"
  key_name               = "chirag-mongo-kp"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.mongo.id]
  subnet_id              = element(module.vpc.public_subnets, 1)

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "mongo" {
  name   = "mongo-sg-chirag"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = [aws_security_group.pritunl-sg.id]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "TCP"
    self        = true
  }
    
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "TCP"
    security_groups = [aws_security_group.nodejs-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg"
    Owner = "chirag"
  }
}

# Jump-server Instances

module "jump-server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "chirag-js"

  ami                    = "ami-0530ca8899fac469f"
  instance_type          = "t3a.small"
  key_name               = "chirag-js"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.chirag-js.id]
  subnet_id              = element(module.vpc.public_subnets, 1)

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "chirag-js" {
  name   = "js-sg-chirag"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg"
    Owner = "chirag"
  }
}
