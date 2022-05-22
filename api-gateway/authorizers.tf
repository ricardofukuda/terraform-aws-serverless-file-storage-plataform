resource "aws_api_gateway_authorizer" "authorizer" {
  name          = "file_service_authorizer"
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_arn]
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
