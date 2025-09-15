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

data "aws_iam_policy_document" "ecr" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      #"ecr:GetDownloadUrlForLayer",
      #"ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = [
      aws_ecr_repository.app.arn,
      aws_ecr_repository.proxy.arn
    ]
  }
}


data "aws_iam_policy_document" "ec2" {
  statement {
    sid    = "VPC"
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:CreateVpc",
      "ec2:ModifyVpcAttribute",
      "ec2:DeleteVpc",
      "ec2:DescribeVpcAttribute",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Subnets"
    effect = "Allow"
    actions = [
      "ec2:DescribeSubnets",
      "ec2:CreateSubnet",
      "ec2:ModifySubnetAttribute",
      "ec2:DeleteSubnet",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "RouteTablesAndRoutes"
    effect = "Allow"
    actions = [
      "ec2:DescribeRouteTables",
      "ec2:CreateRouteTable",
      "ec2:AssociateRouteTable",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:DisassociateRouteTable",
      "ec2:DeleteRouteTable",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "InternetGateways"
    effect = "Allow"
    actions = [
      "ec2:DescribeInternetGateways",
      "ec2:CreateInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:DeleteInternetGateway",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "VpcEndpoints"
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcEndpoints",
      "ec2:CreateVpcEndpoint",
      "ec2:DeleteVpcEndpoints",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SecurityGroups"
    effect = "Allow"
    actions = [
      "ec2:DescribeSecurityGroups",
      "ec2:CreateSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DeleteSecurityGroup",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "NetworkInterfaces"
    effect = "Allow"
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:DetachNetworkInterface",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Miscellaneous"
    effect = "Allow"
    actions = [
      "ec2:DescribeNetworkAcls",
      "ec2:DescribePrefixLists",
      "ec2:CreateTags",
    ]
    resources = ["*"]
  }
}
