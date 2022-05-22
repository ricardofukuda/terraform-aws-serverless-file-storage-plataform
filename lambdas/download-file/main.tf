data "archive_file" "build" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/build/download_file_build.zip"
}

resource "aws_lambda_function" "download_file" {
  function_name    = "download_file"
  role             = aws_iam_role.lambda_download_file.arn
  handler          = "main.handler"
  filename         = data.archive_file.build.output_path
  source_code_hash = data.archive_file.build.output_base64sha256

  runtime = "nodejs12.x"
}
