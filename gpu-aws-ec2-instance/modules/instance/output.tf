output "instance_id" {
  description = "ec2 instance id"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "ec2 instance public ip"
  value       = aws_instance.app_server.public_ip
}

output "private_key_read_permission_command" {
  value = "chmod 400 ${local_file.instance_private_key_pem.filename}"
}

output "instance_ssh_command" {
  description = "ec2 instance public ip"
  value       = local_file.instance_private_key_pem.filename != null ? "ssh ubuntu@${aws_instance.app_server.public_ip} -i ${local_file.instance_private_key_pem.filename}" : "terraform apply will create the private key"
}
