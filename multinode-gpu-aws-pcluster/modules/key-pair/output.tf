output "private_key_name" {
  value = aws_key_pair.key_pair.key_name
}

output "private_key_filename" {
  value = local_file.private_key_pem.filename
}