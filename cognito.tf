resource "aws_cognito_user_pool" "user_pool" {
  name = "file_service_user_pool"
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = "file-service"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

# TEST USER
resource "aws_cognito_user" "user" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  enabled      = true
  username     = "ricardo"
  password     = "superSecret@!!12345"
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                                 = "client"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  callback_urls                        = ["https://${module.file_service_frontend.website_endpoint}"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]

  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
}

output "cognito_domain" {
  value     = aws_cognito_user_pool_domain.user_pool_domain.domain
  sensitive = false
}

output "user_pool_client" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}
