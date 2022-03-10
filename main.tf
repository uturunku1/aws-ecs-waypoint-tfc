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
  name = "ecr-example-nodejs"
}

output "wp_iam_role_name" {
  description = "output the name of my execution IAM role"
  value       = aws_iam_role.tf_waypoint_iam_role.id
}

resource "aws_vpc" "mainvpc" {
  cidr_block = "172.31.0.0/16"
}
#attempting to run terraform import aws_default_security_group.tf_waypoint_security_default sg-60170812
resource "aws_default_security_group" "tf_waypoint_security_default" {
  vpc_id = aws_vpc.mainvpc.id
  # name        = "example-nodejs-inbound-internal" //or should it be the one provided by the external security group "example-nodejs-inbound"
  description = "Allow TLS inbound traffic"
}

output "wp_security_group_internal" {
  description = "output the name of security internal group"
  value       = aws_default_security_group.tf_waypoint_security_default.id
}

#https://support.hashicorp.com/hc/en-us/articles/360061289934-How-to-Import-Resources-into-a-Remote-State-Managed-by-Terraform-Cloud
# Done:
# terraform import aws_ecs_cluster.tf_waypoint_cluster waypoint
# terraform import aws_cloudwatch_log_group.tf_waypoint_logs waypoint-logs
# terraform import aws_iam_role.tf_waypoint_iam_role ecr-example-nodejs

# Speculative plans are not listed the platform's UI. But the url to each of those plans can be found in the PR's checks that ran after each commit.

#Other outputs needed are things that come from these create methods.
#Noting here so we can work through them
# resourceClusterCreate
# resourceExecutionRoleCreate
# resourceInternalSecurityGroupsCreate
# resourceExternalSecurityGroupsCreate
# resourceLogGroupCreate
# resourceServiceSubnetsDiscover
# resourceAlbSubnetsDiscover
# resourceAlbCreate



