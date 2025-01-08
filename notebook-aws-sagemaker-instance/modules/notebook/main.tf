# each sagemaker instance must have a IAM role
resource "aws_iam_role" "sagemaker_role" {
  name = "${var.notebook_name}_sagemaker_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

# allow the sagemaker role to have full access
resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  name                = var.notebook_name
  role_arn            = aws_iam_role.sagemaker_role.arn
  instance_type       = var.instance_type
  platform_identifier = "notebook-al2-v3"
  volume_size         = var.notebook_volume_size
}

# create a S3 bucket to store the inputs and outputs of the training jobs
resource "aws_s3_bucket" "notebook_bucket" {
  bucket = "${var.notebook_name}-notebook-bucket"
}

resource "aws_s3_bucket_versioning" "notebook_bucket_versioning" {
  bucket = aws_s3_bucket.notebook_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "notebook_bucket_encryption" {
  bucket = aws_s3_bucket.notebook_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "notebook_bucket_access" {
  bucket = aws_s3_bucket.notebook_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# allow the sagemaker service to access the bucket
resource "aws_s3_bucket_policy" "notebook_bucket_sagemaker_policy" {
  bucket = aws_s3_bucket.notebook_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSageMakerAccess"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.notebook_bucket.arn,
          "${aws_s3_bucket.notebook_bucket.arn}/*"
        ]
      }
    ]
  })
}

# allow specific sagemaker roles to access the s3 bucket
resource "aws_iam_role_policy" "notebook_bucket_s3_policy" {
  name = "${aws_s3_bucket.notebook_bucket.id}_sagemaker_access"
  role = aws_iam_role.sagemaker_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.notebook_bucket.arn,
          "${aws_s3_bucket.notebook_bucket.arn}/*"
        ]
      }
    ]
  })
}