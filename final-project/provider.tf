terraform {
  backend "s3" {
    bucket = "pla-tf-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = var.aws_region
}
