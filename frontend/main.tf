resource "aws_s3_bucket" "file_service_frontend" {
  bucket = "file-service-frontend-12345"
}

# important
resource "aws_s3_object" "dist" {
  for_each = fileset("${path.module}/src/", "*")

  bucket = aws_s3_bucket.file_service_frontend.bucket
  key    = each.value

  source       = "${path.module}/src/${each.value}"
  etag         = filemd5("${path.module}/src/${each.value}")
  content_type = "text/html" # important
  acl          = "public-read"
}

data "template_file" "variables_js" {
  template = file("${path.module}/variables/variables.js.tpl")
  vars = {
    user_pool_id     = "${var.user_pool_id}"
    user_pool_client = "${var.user_pool_client}"
    API_URL          = "${var.API_URL}"
  }
}

resource "aws_s3_object" "variables_js" {
  bucket       = aws_s3_bucket.file_service_frontend.bucket
  key          = "variables.js"
  content      = data.template_file.variables_js.rendered
  etag         = md5(data.template_file.variables_js.rendered)
  content_type = "application/javascript"
  acl          = "public-read"
}

resource "aws_s3_bucket_website_configuration" "file_service_frontend" {
  bucket = aws_s3_bucket.file_service_frontend.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
