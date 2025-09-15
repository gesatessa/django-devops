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


resource "aws_iam_policy" "tf_backend" {
  name        = "${aws_iam_user.cd.name}-tf-backend-policy"
  description = "Allows access to the S3 bucket and DynamoDB table for Terraform backend"
  policy      = data.aws_iam_policy_document.cd.json
}

resource "aws_iam_user_policy_attachment" "tf_backend_attach" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.tf_backend.arn

}

# ============================ #
# ECR policy for app  #and proxy #
# ============================ #

resource "aws_iam_policy" "ecr" {
  name        = "${aws_iam_user.cd.name}-ecr-policy"
  description = "Allows access to ECR repositories for application and proxy"
  policy      = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_user_policy_attachment" "ecr_attach" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.ecr.arn

}

# ============================ #
# VPC policy for CD user #
# ============================ #

resource "aws_iam_policy" "ec2" {
  name        = "${aws_iam_user.cd.name}-ec2-policy"
  description = "Allows access to manage VPC and related resources"
  policy      = data.aws_iam_policy_document.ec2.json
}
resource "aws_iam_user_policy_attachment" "ec2_attach" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.ec2.arn

}
