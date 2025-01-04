variable "env_name" {
  default = "env"
  type    = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
  type    = string
}

variable "ebs_size_gb" {
  default = 16
  type    = number
}

variable "instance_ami" {
  default = "amzn2-ami-hvm-*-x86_64-gp2"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "instance_name" {
  default = "instance"
  type    = string
}
