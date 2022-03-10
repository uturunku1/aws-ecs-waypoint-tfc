terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "example-org-615f54"
    workspaces {
        name = "luces-waypoint"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.28.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

# provider "aws" {
#   assume_role {
#     role_arn     = "arn:aws:iam::206958406631:role/ecr-example-nodejs" //created by waypoint
#     session_name = "SESSION_NAME"
#     external_id  = "EXTERNAL_ID"
#   }
# }

# resource "aws_ecs_cluster" "tf_waypoint_cluster" {
#   name = "waypoint"

#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }
# }

# output "cluster_name" {
#   description = "output the name of my ecs cluster"
#   value       = aws_s3_cluster.tf_waypoint.id
# }

# //terraform import aws_ecs_cluster.tf_waypoint waypoint

# resource "aws_cloudwatch_log_group" "tf_waypoint_logs" {
#   name = "waypoint-logs"
# }

# resource "aws_security_group" "allow_tls" {
#   name        = "example-nodejs-inbound-internal"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description      = "TLS from VPC"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.main.cidr_block]
#     ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_tls"
#   }
# }

# resource "aws_security_group_rule" "example" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = [aws_vpc.example.cidr_block]
#   ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
#   security_group_id = "sg-123456"
# }


