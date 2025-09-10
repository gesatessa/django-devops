variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "django-recipe"
}

variable "contact" {
  description = "Contact email for the project"
  type        = string
  default     = "info@me.com"
}

variable "tf_state_bucket" {
  description = "The name of the S3 bucket to store the Terraform state"
  type        = string
  default     = "django-recipe-devops"

}

variable "tf_state_lock_table" {
  description = "The name of the DynamoDB table to lock the Terraform state"
  type        = string
  default     = "django-recipe-devops-tf-lock"

}

