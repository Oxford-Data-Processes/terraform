locals {
  rule_name       = "${var.project}-${var.lambda_function_name}-event-bus-rule"
  target_name     = "${var.project}-${var.lambda_function_name}-event-bus-target"
  lambda_function = "${var.project}-${var.lambda_function_name}"
}

module "lambda_function_module" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = local.lambda_function
  create_package = false
  image_uri      = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.lambda_function}-image:${var.version_number}"
  package_type   = "Image"

  environment_variables = {
    STAGE                       = var.stage
    AWS_ACCESS_KEY_ID_ADMIN     = var.aws_access_key_id_admin
    AWS_SECRET_ACCESS_KEY_ADMIN = var.aws_secret_access_key_admin
  }
  timeout     = 900
  memory_size = 2048
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:${var.aws_region}:${var.aws_account_id}:rule/${local.rule_name}"
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = var.bus_name

  rules = {
    local.rule_name = {
      name          = local.rule_name
      event_pattern = jsonencode({ "source": ["com.oxforddataprocesses"] })
      enabled       = true
    }
  }

  targets = {
    local.rule_name = [
      {
        name = local.target_name
        arn  = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${local.lambda_function}"
      },
    ]
  }
}
