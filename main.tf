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

output "wp_cluster_name" {
  description = "output the name of my ecs cluster"
  value       = aws_ecs_cluster.tf_waypoint_cluster.id
}

resource "aws_cloudwatch_log_group" "tf_waypoint_logs" {
  name = "waypoint-logs"
}

output "wp_cloudwatch_logs_name" {
  description = "output the name of my cloudwatch logs"
  value       = aws_cloudwatch_log_group.tf_waypoint_logs.id
}

resource "aws_iam_role" "tf_waypoint_iam_role" {
  name               = "ecr-example-nodejs"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

output "wp_iam_role_name" {
  description = "output the name of my execution IAM role"
  value       = aws_iam_role.tf_waypoint_iam_role.id
}


data "aws_vpc" "inbound_internal" {
  id = "vpc-a2f9c4c4"
}

resource "aws_security_group" "tf_waypoint_inbound_internal" {
  vpc_id = data.aws_vpc.inbound_internal.id
  # id     = "sg-0166caeecca88094f"
  # name   = "example-nodejs-inbound-internal"
  description = "created by waypoint"
}

resource "aws_security_group" "example_nodejs_inbound" {
  vpc_id      = data.aws_vpc.inbound_internal.id
  description = "created by waypoint"
}

output "wp_security_inbound_internal" {
  value = aws_security_group.tf_waypoint_inbound_internal.id
}

output "wp_security_group_app" {
  value = aws_security_group.tf_waypoint_inbound_internal.id
}

resource "aws_iam_role" "ecs_role_name" {
  name = "ecr-example-nodejs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

output "wp_execution_role_arn" {
  value = aws_iam_role.ecs_role_name.arn
}

# supposed to be deprecated but also not working for our version?
data "aws_subnet_ids" "default_subnets" {
  vpc_id = data.aws_vpc.inbound_internal.id
}

output "wp_default_subnets" {
  value = data.aws_subnet_ids.default_subnets.ids
}

#https://support.hashicorp.com/hc/en-us/articles/360061289934-How-to-Import-Resources-into-a-Remote-State-Managed-by-Terraform-Cloud
# Done:
# terraform import aws_ecs_cluster.tf_waypoint_cluster waypoint
# terraform import aws_cloudwatch_log_group.tf_waypoint_logs waypoint-logs
# terraform import aws_iam_role.tf_waypoint_iam_role ecr-example-nodejs
# terraform import aws_security_group.tf_waypoint_inbound_internal sg-0166caeecca88094f
# terraform import aws_security_group.tf_waypoint_inbound sg-0dc34cc1d070b7882

# Speculative plans are not listed the platform's UI. But the url to each of those plans can be found in the PR's checks that ran after each commit.

#Other outputs needed are things that come from these create methods.
#Noting here so we can work through them
# resourceServiceSubnetsDiscover
# resourceAlbSubnetsDiscover
# resourceAlbCreate



