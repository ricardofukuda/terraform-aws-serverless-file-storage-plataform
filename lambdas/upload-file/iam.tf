resource "aws_iam_role" "role" {
  name = "lambda_upload_file"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "policy_doc" {
  statement {
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${var.file_storage_s3_bucket.name}/*"
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "lambda_upload_file"
  policy = data.aws_iam_policy_document.policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_upload_file_attach_1" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_upload_file_attach_2" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
