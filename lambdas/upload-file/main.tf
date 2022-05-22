data "archive_file" "build" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/build/upload_file_build.zip"
}

resource "aws_lambda_function" "upload_file" {
  function_name    = "upload_file"
  role             = aws_iam_role.role.arn
  handler          = "main.handler"
  filename         = data.archive_file.build.output_path
  source_code_hash = data.archive_file.build.output_base64sha256

  runtime = "nodejs12.x"
}
