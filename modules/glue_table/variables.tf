variable "database_name" {
  description = "The name of the Glue database"
  type        = string
}

variable "table_name" {
  description = "The name of the Glue table"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
}

variable "columns" {
  description = "A list of columns for the Glue table"
  type = list(object({
    name = string
    type = string
  }))
}

variable "partition_keys" {
  description = "A list of partition keys for the Glue table"
  type = list(object({
    name = string
    type = string
  }))
}

