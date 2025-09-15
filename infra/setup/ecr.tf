# ======================================================== #
# Terraform Setup for AWS ECR (Elastic Container Registry)  #
# ======================================================== #
resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-app-repo"
  image_tag_mutability = "MUTABLE"

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = var.project_name
    Contact = var.contact
  }
}

resource "aws_ecr_repository" "proxy" {
  name                 = "${var.project_name}-proxy-repo"
  image_tag_mutability = "MUTABLE"

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = var.project_name
    Contact = var.contact
  }

}
