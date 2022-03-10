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

resource "aws_ecs_cluster" "tf_waypoint_cluster" {
  name = "waypoint"
}

output "cluster_name" {
  description = "output the name of my ecs cluster"
  value       = aws_s3_cluster.tf_waypoint_cluster.id
}

#https://support.hashicorp.com/hc/en-us/articles/360061289934-How-to-Import-Resources-into-a-Remote-State-Managed-by-Terraform-Cloud
# Done:
# terraform import aws_ecs_cluster.tf_waypoint_cluster waypoint


# resource "aws_iam_role" "tf_waypoint_iam_role" {
#   name = "ecr-example-nodejs"
# }

# resource "aws_cloudwatch_log_group" "tf_waypoint_logs" {
#   name = "waypoint-logs"
# }

# resource "aws_security_group" "allow_tls" {
#   name        = "example-nodejs-inbound-internal" //or should it be the one provided by the external security group "example-nodejs-inbound"
#   description = "Allow TLS inbound traffic"
# }



