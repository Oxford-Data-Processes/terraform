data "aws_iam_policy_document" "sqs_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions   = ["SQS:SendMessage"]
    resources = [aws_sqs_queue.sqs_queue.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.project_notifications.arn]
    }
  }
}