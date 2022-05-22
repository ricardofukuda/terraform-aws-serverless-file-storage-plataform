resource "aws_s3_bucket" "upload_file_storage" {
  bucket = "file-service-storage-12345"
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.upload_file_storage.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["http://${module.file_service_frontend.website_endpoint}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 600
  }
}

module "lambda_upload_file" {
  source = "./lambdas/upload-file"

  file_storage_s3_bucket = {
    name = aws_s3_bucket.upload_file_storage.id
  }
}

module "file_service_frontend" {
  source = "./frontend"

  user_pool_id     = aws_cognito_user_pool.user_pool.id
  user_pool_client = aws_cognito_user_pool_client.user_pool_client.id
  API_URL          = module.file_service_apigateway.api_url
}

module "file_service_apigateway" {
  source     = "./api-gateway"
  depends_on = [module.lambda_upload_file]

  cognito_arn = aws_cognito_user_pool.user_pool.arn
  origin_host = module.file_service_frontend.website_endpoint
  lambda_upload_file = {
    arn  = module.lambda_upload_file.lambda_upload_file_arn
    name = module.lambda_upload_file.lambda_upload_file_name
  }
}
