resource "aws_sqs_queue" "sqs_queue" {
  name                      = "${var.project}-${var.service_name}-queue"
  delay_seconds             = 0
  max_message_size          = 262144  
  message_retention_seconds = 345600 
  receive_wait_time_seconds = 0       
}

resource "aws_sns_topic" "project_notifications" {
  name = "${var.project}-${var.service_name}-notifications"
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.project_notifications.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_queue.arn

  raw_message_delivery = true
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}