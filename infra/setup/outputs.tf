output "cd_user_access_key_id" {
  value       = aws_iam_access_key.cd.id
  description = "Access key ID for the CD user"
}

output "cd_user_secret_access_key" {
  value       = aws_iam_access_key.cd.secret
  description = "Secret access key for the CD user"
  sensitive   = true
}

output "ecr_app_repository_url" {
  value       = aws_ecr_repository.app.repository_url
  description = "URL of the ECR repository for the application"
}

output "ecr_proxy_repository_url" {
  value       = aws_ecr_repository.proxy.repository_url
  description = "URL of the ECR repository for the proxy"
}
