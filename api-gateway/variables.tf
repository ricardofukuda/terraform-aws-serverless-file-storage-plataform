variable "cognito_arn" {
  type    = string
  default = ""
}

variable "lambda_upload_file" {
  type = object({
    name = string
    arn  = string
  })
}

variable "origin_host" {
  type    = string
  default = ""
}
