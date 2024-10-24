
module "process_data_lambda" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "${var.project}-${var.lambda_function_name}"
  create_package = false
  image_uri      = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.project}-${var.lambda_function_name}-image:${var.version_number}"
  package_type   = "Image"

  environment_variables = {
    STAGE                       = var.stage
    AWS_ACCESS_KEY_ID_ADMIN     = var.aws_access_key_id_admin
    AWS_SECRET_ACCESS_KEY_ADMIN = var.aws_secret_access_key_admin
  }
  timeout     = 900
  memory_size = 2048
}
