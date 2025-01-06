resource "aws_iam_role" "sagemaker_role" {
  name = "${var.notebook_name}_role"

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

resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  name                    = var.notebook_name
  role_arn               = aws_iam_role.sagemaker_role.arn
  instance_type          = var.instance_type
  platform_identifier    = "notebook-al2-v3"
}