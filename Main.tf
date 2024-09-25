terraform {
  backend "s3" {
    bucket = "ms-lanchonete"
    key    = "deployment-service/terraform.tfstate"
    region = "us-east-1"
  }
}

module "mslanchonete" {
  source = "./infra"

  project_name = var.projectname
  region       = var.aws_region
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "projectname" {
  type        = string
  default     = "mslanchonete"
  description = "Application Name"
}

output "endereco" {
  value = module.mslanchonete.load_balancer_hostname
}

# output "nomeLB" {
#   value = module.mslanchonete.load_balancer_name
# }

# output "LBinfo" {
#   value = module.mslanchonete.load_balancer_info
# }