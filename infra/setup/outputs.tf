output "cd_user_access_key_id" {
  value       = aws_iam_access_key.cd.id
  description = "Access key ID for the CD user"
}

output "cd_user_secret_access_key" {
  value       = aws_iam_access_key.cd.secret
  description = "Secret access key for the CD user"
  sensitive   = true
}
