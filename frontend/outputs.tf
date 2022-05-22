output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.file_service_frontend.website_endpoint
}
