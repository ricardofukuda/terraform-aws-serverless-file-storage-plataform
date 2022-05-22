output "lambda_upload_file_arn" {
  value = aws_lambda_function.upload_file.invoke_arn
}

output "lambda_upload_file_name" {
  value = aws_lambda_function.upload_file.function_name
}
