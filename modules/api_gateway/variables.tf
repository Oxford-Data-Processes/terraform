variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the Lambda function is deployed"
  type        = string
}

variable "stage" {
  description = "The deployment stage (e.g., dev, test, prod)"
  type        = string
}

variable "aws_access_key_id_admin" {
  description = "The AWS access key ID for the admin user"
  type        = string
}

variable "aws_secret_access_key_admin" {
  description = "The AWS secret access key for the admin user"
  type        = string
}

variable "version_number" {
  description = "The version number of the Lambda function"
  type        = string
}

variable "api_resource_path_part" {
  description = "The path part of the API resource"
  type        = string
}
