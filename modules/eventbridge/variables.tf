variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the Lambda function is deployed"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "event_pattern" {
  description = "The event pattern for the EventBridge rule"
  type        = string
}
