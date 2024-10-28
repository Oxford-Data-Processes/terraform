
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:${var.aws_region}:${var.aws_account_id}:rule/${local.rule_name}"
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "${var.project}-${var.lambda_function_name}-event-bus"

  rules = {
    global_event_bus = {
      name          = local.rule_name
      event_pattern = jsonencode({ "source": ["com.oxforddataprocesses"] })
      enabled       = true
    }
  }

  targets = {
    global_event_bus = [
      {
        name = local.target_name
        arn  = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${local.lambda_function}"
      },
    ]
  }
}
