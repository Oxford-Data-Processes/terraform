module "lambda_module" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = var.lambda_function_name
  create_package = false
  image_uri      = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.lambda_function_name}-image:${var.version_number}"
  package_type   = "Image"

  environment_variables = {
    STAGE                       = var.stage
    AWS_ACCESS_KEY_ID_ADMIN     = var.aws_access_key_id_admin
    AWS_SECRET_ACCESS_KEY_ADMIN = var.aws_secret_access_key_id_admin
  }
  timeout     = 900
  memory_size = 2048
}

resource "null_resource" "cleanup_old_versions" {
  triggers = {
    image_uri = module.lambda_module.image_uri
  }
  
  provisioner "local-exec" {
    command = <<EOT
      aws lambda list-versions-by-function --function-name ${var.lambda_function_name} --query 'Versions[?Version!=`$LATEST`].Version' --output text | xargs -I {} aws lambda delete-function --function-name ${var.lambda_function_name} --qualifier {}
    EOT
  }
}
