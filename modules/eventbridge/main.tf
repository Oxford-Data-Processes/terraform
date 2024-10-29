resource "aws_cloudwatch_event_bus" "event_bus" {
  name = "${var.project}-${var.lambda_function_name}-event-bus"
}

resource "aws_cloudwatch_event_rule" "event_bus_rule" {
  name               = "${var.project}-${var.lambda_function_name}-event-bus-rule"
  event_bus_name     = aws_cloudwatch_event_bus.event_bus.name
  event_pattern      = var.event_pattern
  state              = "ENABLED"
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = "${var.project}-${var.lambda_function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_bus_rule.arn
}

resource "aws_cloudwatch_event_target" "event_bus_target" {
  rule          = aws_cloudwatch_event_rule.event_bus_rule.name
  event_bus_name = aws_cloudwatch_event_bus.event_bus.name
  arn           = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.project}-${var.lambda_function_name}"
  target_id     = "${var.project}-${var.lambda_function_name}-target"
}