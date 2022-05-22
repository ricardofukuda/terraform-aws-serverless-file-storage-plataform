output "lambda_download_file_arn" {
  value = aws_lambda_function.download_file.invoke_arn
}

output "lambda_download_file_name" {
  value = aws_lambda_function.download_file.function_name
}
