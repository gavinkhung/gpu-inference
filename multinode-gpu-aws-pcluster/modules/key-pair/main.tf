# create a RSA key to SSH into the instance
resource "tls_private_key" "rsa_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.rsa_private_key.private_key_pem
  filename = "${var.key_name}.pem"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_private_key.public_key_openssh

  tags = {
    Name = var.key_name
  }
}
