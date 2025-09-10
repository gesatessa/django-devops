variable "prefix" {
  description = "The prefix to use for resource names"
  type        = string
  default     = "raa"
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

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}