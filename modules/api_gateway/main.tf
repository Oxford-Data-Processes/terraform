locals {
  lambda_function_name = "${var.project}-api-lambda"
  api_lambda_arn       = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.project}-api-lambda"
}

module "api_gateway_lambda" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = local.lambda_function_name
  create_package = false
  image_uri      = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.lambda_function_name}-image:${var.version_number}"
  package_type   = "Image"

  environment_variables = {
    STAGE                       = var.stage
    AWS_ACCESS_KEY_ID_ADMIN     = var.aws_access_key_id_admin
    AWS_SECRET_ACCESS_KEY_ADMIN = var.aws_secret_access_key_admin
  }
  timeout     = 900
  memory_size = 2048
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.project}-api"
}

resource "aws_api_gateway_resource" "api_resource" {
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "items"
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_method" "api_get_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_integration" "api_integration_get" {
  http_method = aws_api_gateway_method.api_get_method.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  integration_http_method = "POST"
  type        = "AWS_PROXY"

  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${local.api_lambda_arn}/invocations"
}

resource "aws_api_gateway_method" "api_post_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_integration" "api_integration_post" {
  http_method = aws_api_gateway_method.api_post_method.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  integration_http_method = "POST"
  type        = "AWS_PROXY"

  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${local.api_lambda_arn}/invocations"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_resource.id,
      aws_api_gateway_method.api_get_method.id,
      aws_api_gateway_integration.api_integration_get.id,
      aws_api_gateway_method.api_post_method.id,
      aws_api_gateway_integration.api_integration_post.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.stage
}
