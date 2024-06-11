
### IAM role for the SageMaker Notebook.

# SageMaker role
resource "aws_iam_role" "notebook_role" {
  name               = local.notebook_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.notebook_role.json

  tags = merge({
    Name = local.notebook_role_name
  }, var.tags)
}

# Trusted identity
data "aws_iam_policy_document" "notebook_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

# Attach the SageMaker Full Access managed policy. - Not needed for only the SageMaker Notebook
# resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
#   role       = aws_iam_role.notebook_role.name
#   policy_arn = data.aws_iam_policy.sagemaker_full_access.arn
# }

# Add policy specifying Get/Put access on the dedicated sagemaker notebook bucket.
resource "aws_iam_role_policy" "notebook_bucket_access" {
  name   = "GetPutBucket-${local.notebook_bucket_name}"
  role   = aws_iam_role.notebook_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AllowBucket",
        "Effect": "Allow",
        "Action": [
            "s3:PutObject",
            "s3:ListBucket",
            "s3:GetObject"
        ],
        "Resource": [
            "${module.notebook_bucket.bucket_arn}",
            "${module.notebook_bucket.bucket_arn}/*"
        ]
    }
  ]
}
EOF
}

### Additional policies
resource "aws_iam_role_policy_attachment" "additional" {
  for_each   = var.notebook_policy_arns
  role       = aws_iam_role.notebook_role.name
  policy_arn = each.value
}

