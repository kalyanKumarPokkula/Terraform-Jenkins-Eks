# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["246302204773"] // Canonical account ID for Ubuntu AMIs

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240301"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }


data "aws_availability_zones" "azs" {}