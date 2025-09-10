# ================================================== #
# IAM user & policies for continuous deployment (CD) #
# ================================================== #

resource "aws_iam_user" "cd" {
  #name = "cd-user-${terraform.workspace}"
  name = "${var.project_name}-cd-user"
}

resource "aws_iam_access_key" "cd" {
  user = aws_iam_user.cd.name
}

data "aws_iam_policy_document" "cd" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.tf_state_bucket}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${var.tf_state_bucket}/tfstate-deploy/*",
      "arn:aws:s3:::${var.tf_state_bucket}/tfstate-deploy-env/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem"
    ]

    resources = ["arn:aws:dynamodb:${var.aws_region}:*:table/${var.tf_state_lock_table}"]
  }
}

resource "aws_iam_policy" "tf_backend" {
  name        = "${aws_iam_user.cd.name}-tf-backend-policy"
  description = "Allows access to the S3 bucket and DynamoDB table for Terraform backend"
  policy      = data.aws_iam_policy_document.cd.json
}

resource "aws_iam_user_policy_attachment" "tf_backend_attach" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.tf_backend.arn

}
