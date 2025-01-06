provider "aws" {
  region = var.region
}

module "notebook" {
  source = "../../modules/notebook"

  instance_type = "ml.t3.medium"
  # instance_type = "ml.p3.2xlarge"

  notebook_name = "instance"
}