resource "aws_api_gateway_resource" "upload_file" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "upload_file"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

# Method
resource "aws_api_gateway_method" "upload_file" {
  http_method = "POST"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.authorizer.id

  resource_id = aws_api_gateway_resource.upload_file.id
  rest_api_id = aws_api_gateway_rest_api.api.id

  # Method Request
  request_models = {
    "application/json" = "Empty"
  }
}

# Method Response
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.upload_file.id
  http_method = aws_api_gateway_method.upload_file.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}


resource "aws_api_gateway_integration" "file_service" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.upload_file.id
  http_method             = aws_api_gateway_method.upload_file.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_upload_file.arn
}

# Integration Response
resource "aws_api_gateway_integration_response" "file_service" {
  http_method       = aws_api_gateway_method.upload_file.http_method
  resource_id       = aws_api_gateway_resource.upload_file.id
  rest_api_id       = aws_api_gateway_rest_api.api.id
  status_code       = aws_api_gateway_method_response.response_200.status_code
  selection_pattern = aws_api_gateway_method_response.response_200.status_code

  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{}
EOF
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}





# Method
resource "aws_api_gateway_method" "upload_file_options" {
  http_method = "OPTIONS"

  authorization = "NONE"

  resource_id = aws_api_gateway_resource.upload_file.id
  rest_api_id = aws_api_gateway_rest_api.api.id

  # Method Request
  request_models = {
    "application/json" = "Empty"
  }
}

# Method Response
resource "aws_api_gateway_method_response" "response_200_options" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.upload_file.id
  http_method = aws_api_gateway_method.upload_file_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
    "method.response.header.Access-Control-Max-Age"       = false
  }
}

resource "aws_api_gateway_integration" "upload_file" {
  http_method = aws_api_gateway_method.upload_file_options.http_method
  resource_id = aws_api_gateway_resource.upload_file.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  type        = "MOCK"

  # Integration Request
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
}

# Integration Response
resource "aws_api_gateway_integration_response" "upload_file_options" {
  http_method       = aws_api_gateway_method.upload_file_options.http_method
  resource_id       = aws_api_gateway_resource.upload_file.id
  rest_api_id       = aws_api_gateway_rest_api.api.id
  status_code       = aws_api_gateway_method_response.response_200_options.status_code
  selection_pattern = aws_api_gateway_method_response.response_200_options.status_code

  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{}
EOF
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'content-type,X-Amz-Date,authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'http://${var.origin_host}'"
    "method.response.header.Access-Control-Max-Age"       = "'600'"
  }
}
