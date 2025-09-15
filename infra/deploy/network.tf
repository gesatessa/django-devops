resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.prefix}-main-vpc"
  }

}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.prefix}-main-igw"
  }

}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 0)
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "${local.prefix}-public-subnet-1"
  }
}

resource "aws_route_table" "public_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.prefix}-public-rt-1"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_1.id

}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# private subnet for internal resources only ========================== #
# ===================================================================== #
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 1)
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${local.prefix}-private-subnet-1"
  }

}


# endpoints to allow private subnet access to S3 and DynamoDB ========== #
# ===================================================================== #
resource "aws_security_group" "endpoint_access" {
  name        = "${local.prefix}-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name = "${local.prefix}-endpoint-sg"
  }

}

resource "aws_vpc_endpoint" "ecr" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_1.id]
  security_group_ids = [aws_security_group.endpoint_access.id]

  private_dns_enabled = true

  tags = {
    Name = "${local.prefix}-ecr-endpoint"
  }

}

resource "aws_vpc_endpoint" "dkr" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_1.id]
  security_group_ids = [aws_security_group.endpoint_access.id]

  private_dns_enabled = true

  tags = {
    Name = "${local.prefix}-ecr-dkr-endpoint"
  }

}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_1.id]
  security_group_ids = [aws_security_group.endpoint_access.id]

  private_dns_enabled = true

  tags = {
    Name = "${local.prefix}-cw-logs-endpoint"
  }

}

# resource "aws_vpc_endpoint" "ssm" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.${data.aws_regions.current.name}.ssm"
#   vpc_endpoint_type = "Interface"
#   subnet_ids        = [aws_subnet.private_1.id]
#   security_group_ids = [aws_security_group.endpoint_access.id]

#   private_dns_enabled = true

#   tags = {
#     Name = "${local.prefix}-ssm-endpoint"
#   }

# }
resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_1.id]
  security_group_ids = [aws_security_group.endpoint_access.id]

  private_dns_enabled = true

  tags = {
    Name = "${local.prefix}-ssm-messages-endpoint"
  }

}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  #route_table_ids   = [aws_route_table.public_1.id]
  route_table_ids = [aws_vpc.main.default_route_table_id]

  tags = {
    Name = "${local.prefix}-s3-endpoint"
  }

}
# ===================================================================== #
