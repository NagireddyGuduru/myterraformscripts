variable "vpc_cidr" {
  type    = "string"
  default = "10.20.0.0/16"
}

variable "vpc_tenancy" {
  default = "default"
  type    = "string"
}

variable "web_subnets_cird" {
  type    = "list"
  default = ["10.20.0.0/24", "10.20.1.0/24"]
}

variable "rds_subnets_cird" {
  type    = "list"
  default = ["10.20.2.0/24", "10.20.3.0/24"]
}

variable "azs" {
  default = ["ap-south-1a", "ap-south-1b"]
}

# Get list of Availability Zones based on provider region
data "aws_availability_zones" "azs" {}

