variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "stage" {
  type = string
}

variable "project" {
  type = string
}

variable "aws_access_key_id_admin" {
  type = string
}

variable "aws_secret_access_key_admin" {
  type = string
}

variable "version_number" {
  type = string
}
