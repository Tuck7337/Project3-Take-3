variable "aws_account_id" {
  default = "797918408294"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = "vpc-0bf27bf861c3bad7f"
}

variable "subnets" {
  type = list(string)
  default = [
    "subnet-0241e6f63ec8f841f",
    # "subnet-0d819d89928921573",
    "subnet-03f5cb450c750d610",
    # "subnet-01eb68e3ae59a015d"
  ]
}

variable "image_repo_name" {
  default = "weather-application-demo"
}

variable "image_tag" {
  default = "latest"
}

variable "image_repo_url" {
  default = "797918408294.dkr.ecr.us-east-1.amazonaws.com/weather-app-demo"
}

variable "github_repo_owner" {
  default = "Tuck7337"
}

variable "github_repo_name" {
  default = "Project3-Take-3"
}

variable "github_branch" {
  default = "main"
}
