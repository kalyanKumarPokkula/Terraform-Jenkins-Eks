#vpc

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "jenkins-vpc"
#   cidr = "10.0.0.0/16"

#   azs            = data.aws_availability_zones.azs.names
#   public_subnets = var.public_subnets

#   enable_dns_hostnames = true

#   tags = {
#     Name        = "jenkins-vpc"
#     Terraform   = "true"
#     Environment = "dev"
#   }

#   public_subnet_tags = {
#     Name = "jenkins-subnet"
#   }
# }


#SG

module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "Security group for jenkins servers"
  # vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All ICMP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name        = "jenkins-sg"
    Terraform   = "true"
    Environment = "dev"
  }
}

#EC2

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  ami                         = "ami-0a1b648e2cd533174"
  instance_type               = var.instance_type
  key_name                    = "AWS_LOGIN"
  monitoring                  = true
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  # subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")
  # availability_zone           = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "jenkins-server",
    Terraform   = "true"
    Environment = "dev"
  }
}