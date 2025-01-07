provider "aws" {
  region = var.region
}

module "instance" {
  source = "./modules/key-pair"

  key_name = "pcluster_key_pair"
}
