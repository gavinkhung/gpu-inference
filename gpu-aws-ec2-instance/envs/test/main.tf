provider "aws" {
  region = var.region
}

module "instance" {
  source = "../../modules/instance"

  env_name = "test"

  vpc_cidr     = "10.0.0.0/16"
  subnet_cidr  = "10.0.0.0/24"
  ebs_size_gb  = 16


  # instance_ami = "amzn2-ami-hvm-*-x86_64-gp2"
  # instance_ami = "Deep Learning Base OSS Nvidia Driver GPU AMI*Ubuntu 22.04*"
  instance_ami = "Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.5*Ubuntu 22.04*"

  # must be compatible with the ami
  # instance_type = "t2.micro"

  # https://aws.amazon.com/ec2/instance-types/g4/
  instance_type = "g4dn.2xlarge"
  # instance_type = "g4dn.12xlarge"

  instance_name = "instance"
}
