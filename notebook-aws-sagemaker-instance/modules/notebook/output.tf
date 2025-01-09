output "aws_sagemaker_role_arn" {
  value = aws_iam_role.sagemaker_role.arn
}

output "aws_sagemaker_notebook_url" {
  value = aws_sagemaker_notebook_instance.notebook.url
}

output "bucket_name" {
  value = aws_s3_bucket.notebook_bucket.id
}
