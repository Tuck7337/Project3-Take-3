variable "aws_account_id" {
  default = "902107193506"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "vpc_id" {
  default = "vpc-05035bf257cf152ce"
}

variable "subnets" {
  type = list(string)
  default = [
    "subnet-0bf4b2a7917b38ae8",
    "subnet-0958e1e512b95af14",
    "subnet-0914e9eee28e4b50e",
    "subnet-057f5b4a52ce48fc5"
  ]
}

variable "image_repo_name" {
  default = "flask-application-demo"
}

variable "image_tag" {
  default = "latest"
}

variable "image_repo_url" {
  default = "902107193506.dkr.ecr.us-west-2.amazonaws.com/flask-application-demo"
}

variable "github_repo_owner" {
  default = "m3rryqold"
}

variable "github_repo_name" {
  default = "terraform-ecs-codepipeline-flask-demo"
}

variable "github_branch" {
  default = "main"
}