resource "aws_api_gateway_rest_api" "api" {
  name = "file_service"
}

resource "aws_api_gateway_deployment" "file_service" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.upload_file.id,

      aws_api_gateway_method.upload_file.id,
      aws_api_gateway_integration.file_service.id,

      aws_api_gateway_method.upload_file_options.id,
      aws_api_gateway_method_response.response_200_options.id,
      aws_api_gateway_integration.upload_file.id,
      aws_api_gateway_integration_response.upload_file_options.id
    ]))
  }
}

resource "aws_api_gateway_stage" "file_service" {
  deployment_id = aws_api_gateway_deployment.file_service.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_upload_file.name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-1:127923327338:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.upload_file.http_method}${aws_api_gateway_resource.upload_file.path}"
}
