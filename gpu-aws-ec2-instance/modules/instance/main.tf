resource "aws_vpc" "instance_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env_name}_${var.instance_name}_vpc"
  }
}

resource "aws_subnet" "instance_subnet" {
  vpc_id     = aws_vpc.instance_vpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "${var.env_name}_${var.instance_name}_subnet"
  }
}

resource "aws_internet_gateway" "instance_internet_gateway" {
  vpc_id = aws_vpc.instance_vpc.id

  tags = {
    Name = "${var.env_name}_${var.instance_name}_internet_gateway"
  }
}

# use a route table to connect IP addresses from Internet
resource "aws_route_table" "instance_route_table" {
  vpc_id = aws_vpc.instance_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.instance_internet_gateway.id
  }

  tags = {
    Name = "${var.env_name}_${var.instance_name}_route_table"
  }
}

resource "aws_route_table_association" "instance_route_table_association" {
  subnet_id      = aws_subnet.instance_subnet.id
  route_table_id = aws_route_table.instance_route_table.id
}

# open ec2 to HTTP traffic
resource "aws_security_group" "instance_security_group" {
  name   = "${var.env_name}_${var.instance_name}_security_group"
  vpc_id = aws_vpc.instance_vpc.id
  tags = {
    Name = "${var.env_name}_${var.instance_name}_security_group"
  }
}

# SSH runs on port 22
resource "aws_vpc_security_group_ingress_rule" "instance_ingress_rule_ssh" {
  security_group_id = aws_security_group.instance_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  tags = {
    Name = "${var.env_name}_${var.instance_name}_security_group_ingress_ssh"
  }
}

# Jupyter Notebook runs on port 8888
resource "aws_vpc_security_group_ingress_rule" "instance_ingress_rule_jupyter" {
  security_group_id = aws_security_group.instance_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8888
  ip_protocol = "tcp"
  to_port     = 8888

  tags = {
    Name = "${var.env_name}_${var.instance_name}_security_group_ingress_jupyter"
  }
}

resource "aws_vpc_security_group_egress_rule" "instance_egress_rule" {
  security_group_id = aws_security_group.instance_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = -1
  to_port     = 0

  tags = {
    Name = "${var.env_name}_${var.instance_name}_security_group_egress"
  }
}

# create a RSA key to SSH into the instance
resource "tls_private_key" "rsa_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "instance_private_key_pem" {
  content  = tls_private_key.rsa_private_key.private_key_pem
  filename = "private-key.pem"
}

resource "aws_key_pair" "instance_key_pair" {
  key_name   = "${var.env_name}_${var.instance_name}_key_pair"
  public_key = tls_private_key.rsa_private_key.public_key_openssh

  tags = {
    Name = "${var.env_name}_${var.instance_name}_key_pair"
  }
}

data "aws_ami" "instance_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.instance_ami]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.instance_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
  key_name               = aws_key_pair.instance_key_pair.key_name

  subnet_id                   = aws_subnet.instance_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "${var.env_name}_${var.instance_name}_ec2"
  }
}

resource "aws_ebs_volume" "instance_ebs_volume" {
  availability_zone = aws_instance.app_server.availability_zone
  size              = var.ebs_size_gb

  tags = {
    Name = "${var.env_name}_${var.instance_name}_ebs_volume"
  }
}

resource "aws_volume_attachment" "instance_ebs_volume_attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.instance_ebs_volume.id
  instance_id = aws_instance.app_server.id
}