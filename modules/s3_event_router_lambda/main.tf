locals {
  lambda_function_name = "s3-event-router-lambda"
}

module "s3_event_router_lambda" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "${var.project}-${local.lambda_function_name}"
  create_package = false
  image_uri      = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.project}-${local.lambda_function_name}-image:${var.version_number}"
  package_type   = "Image"

  environment_variables = {
    STAGE                       = var.stage
    AWS_ACCESS_KEY_ID_ADMIN     = var.aws_access_key_id_admin
    AWS_SECRET_ACCESS_KEY_ADMIN = var.aws_secret_access_key_admin
  }
  timeout     = 900
  memory_size = 2048
}

resource "aws_lambda_permission" "allow_s3_event_router" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = "${var.project}-${local.lambda_function_name}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.project}-bucket-${var.aws_account_id}"
}

resource "aws_s3_bucket_notification" "s3_event_router" {
  bucket = "${var.project}-bucket-${var.aws_account_id}"

  lambda_function {
    events = ["s3:ObjectCreated:*"]
    lambda_function_arn = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.project}-${local.lambda_function_name}"
  }

  depends_on = [aws_lambda_permission.allow_s3_event_router]
}
