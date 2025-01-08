output "aws_sagemaker_notebook_url" {
  value = aws_sagemaker_notebook_instance.notebook.url
}

output "bucket_name" {
  value = aws_s3_bucket.notebook_bucket.id
}
