# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "jobassist"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
