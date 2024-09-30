
# resource "<provider>_<resource_type>" "name" {
#   config options...
#   key = "value"
#   key2 = "another value"
# }

#resource is the block; kinda like a function block
#local is the "provider" and file is the "resource type"
#name is the reference name. You can name it whatever you want
#config options are the options for the resource
#key = "value" is an argument for the resource
#key2 = "another value" is another argument for the resource

# resource "local_file" "pet" {
#     filename = "./pet.txt"
#     content = "I love pets!"
# }

# resource "local_file" "pet2" {
#     filename = "./pet2.txt"
#     content = "I love pets too!"
# }

# resource "local_file" "foo" {
#     content  = "foo!"
#     filename = "foo.bar"
# }

# 1. write your configuration file
# 2. run "terraform init" command
# 3. review execution with "terraform plan"

# resource "local_file" "games" {
#     content  = "FIFA 2025\nPES 2025\n"
#     filename = "./games.txt"
#     file_permission = "0444" # octal value
# }


# 1. Create VPC
# 2. Create Internet Gateway
# 3. Create Custom Route Table
# 4. Create Subnet
# 5. Associate Route Table with Subnet
# 6. Create Security Group to allow port 22,80,443
# 7. Create Network Interface with an IP in the subnet that was created in step 4
# 8. Assign an elastic IP to the network interface created in step 7
# 9. Create an Ubuntu server and install apache2
# 10. Output the IP of the server


terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-west-2"
}

# # 1. Create VPC
# resource "aws_vpc" "MOBANN-VPC" {
#     cidr_block       = "10.0.0.0/16"
#     instance_tenancy = "default"

#     tags = {
#         Name = "MOBANN-VPC"
#     }
# }

# # 2. Create Internet Gateway
# resource "aws_internet_gateway" "MOBANN-IGw" {
#     vpc_id = aws_vpc.MOBANN-VPC.id

#     tags = {
#         Name = "MOBANN-IGw"
#     }
# }

# # 3. Create Custom Route Table
# resource "aws_route_table" "MOBANN-RT" {
#     vpc_id = aws_vpc.MOBANN-VPC.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.MOBANN-IGw.id
#     }

#     tags = {
#         Name = "MOBANN-RT"
#     }
# }

# # 4. Create Subnet
# resource "aws_subnet" "MOBANN-SUBNET" {
#     vpc_id     = aws_vpc.MOBANN-VPC.id
#     cidr_block = "10.0.1.0/24"
#     availability_zone = "us-west-2a"

#     tags = {
#         Name = "MOBANN-SUBNET"
#     }
# }

# # 5. Associate Route Table with Subnet
# resource "aws_route_table_association" "a" {
#     subnet_id      = aws_subnet.MOBANN-SUBNET.id
#     route_table_id = aws_route_table.MOBANN-RT.id
# }

# # 6. Create Security Group to allow port 22,80,443
# resource "aws_security_group" "MOBANN-SG" {
#     name        = "MOBANN-SG"
#     description = "Allow SSH, HTTP, and HTTPS traffic"
#     vpc_id      = aws_vpc.MOBANN-VPC.id

#     ingress {
#         description = "SSH Traffic"
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     ingress {
#         description = "HTTP Traffic"
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     ingress {
#         description = "HTTPS Traffic"
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags = {
#         Name = "MOBANN-SG"
#     }
# }

# # 7. Create Network Interface with an IP in the subnet that was created in step 4
# resource "aws_network_interface" "MOBANN-NIC" {
#     subnet_id       = aws_subnet.MOBANN-SUBNET.id
#     private_ips     = ["10.0.1.50"]
#     security_groups = [aws_security_group.MOBANN-SG.id]
# }

# # 8. Assign an elastic IP to the network interface created in step 7
# resource "aws_eip" "MOBANN-EIP" {
#     domain = "vpc"
#     network_interface         = aws_network_interface.MOBANN-NIC.id
#     associate_with_private_ip = "10.0.1.50"
#     depends_on                = [aws_internet_gateway.MOBANN-IGw]
# }

# # 9. Create an Ubuntu server and install apache2
# resource "aws_instance" "MOBANN-EC2" {
#     ami           = "ami-0e91a55fe7d0fe161"
#     instance_type = "t3.micro"
#     availability_zone = "us-west-2a"
#     key_name = "main-key"
#     depends_on = [ aws_eip.MOBANN-EIP ]

#     network_interface {
#         device_index = 0
#         network_interface_id = aws_network_interface.MOBANN-NIC.id
#     }

#     user_data = <<-EOF
#                 #!/bin/bash
#                 sudo apt update -y
#                 sudo apt install -y apache2
#                 sudo systemctl start apache2
#                 sudo systemctl enable apache2
#                 sudo bash -c 'echo "Welcome Pelumhi" > /var/www/html/index.html'
#                 EOF

#     tags = {
#         Name = "MOBANN-EC2"
#     }
# }

# # 10. Output the IP of the server
# output "server_public_ip" {
#     value = aws_eip.MOBANN-EIP.public_ip
# }

# output "server_private_ip" {
#     value = aws_instance.MOBANN-EC2.private_ip
# }

# ---------------------------------------------------------------------------------------------

# Generate a new RSA key pair [https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key#example-usage]
# resource "tls_private_key" "MOBANN-KEY" {
#     algorithm = "RSA"
#     rsa_bits = 4096
# }

# # create a new AWS Key Pair using the tls_private_key resource
# resource "aws_key_pair" "MOBANN-KP" {
#     key_name = "MOBANN-KP"
#     public_key = tls_private_key.MOBANN-KEY.public_key_openssh
# }

# # create a local file to store the private key
# resource "local_file" "MOBANN-PRIVATE-KEY" {
#     filename = "../MOBANN-PRIVATE-KEY.pem"
#     file_permission = 0400
#     content = tls_private_key.MOBANN-KEY.private_key_pem
# }

# # get latest Amazon Linux 2 AMI https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami#example-usage
# data "aws_ami" "MOBANN-AMI" {
#     owners = ["amazon"]
#     most_recent = true

#     filter {
#         name = "name"
#         values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#     }
# }

# # create security group for the EC2 instance
# resource "aws_security_group" "MOBANN-SG" {
#     name        = "MOBANN-SG_web_traffic"
#     description = "Allow SSH traffic"

#     ingress {
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     ingress {
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags = {
#         Name = "MOBANN-SG"
#     }
# }

# # create an EC2 instance
# resource "aws_instance" "MOBANN-EC2" {
#     ami           = data.aws_ami.MOBANN-AMI.id #interpolation
#     instance_type = "t3.micro"
#     key_name = aws_key_pair.MOBANN-KP.key_name
#     vpc_security_group_ids = [ aws_security_group.MOBANN-SG.id ]
#     user_data = file("user_data.tpl")

#     tags = {
#         Name = "MOBANN-EC2*"
#     }
# }

# # create a launch template
# resource "aws_launch_template" "MOBANN-TEMPLATE" {
#     name = "MOBANN-TEMPLATE"
#     image_id = data.aws_ami.MOBANN-AMI.id
#     instance_type = "t3.micro"
#     key_name = aws_key_pair.MOBANN-KP.key_name
#     vpc_security_group_ids = [ aws_security_group.MOBANN-SG.id ]
#     user_data = filebase64("user_data.tpl")
#     tags = {
#         Name = "MOBANN-TEMPLATE"
#     }
# }

# # create an autoscaling group
# resource "aws_autoscaling_group" "MOBANN-ASG" {
#     name                = "MOBANN-ASG"
#     max_size            = 3
#     min_size            = 2
#     desired_capacity    = 2
#     availability_zones = [ "us-west-2a", "us-west-2b" ]
#     launch_template {
#         id = aws_launch_template.MOBANN-TEMPLATE.id
#         version = "$Latest"
#     }
#     tag {
#         key                 = "Name"
#         value               = "MOBANN-ASG"
#         propagate_at_launch = true
#     }
# }