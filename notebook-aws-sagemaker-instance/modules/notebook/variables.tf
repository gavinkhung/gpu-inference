variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "notebook_name" {
  default = "instance"
  type    = string
}

variable "notebook_volume_size" {
  default = 32
  type    = number
}