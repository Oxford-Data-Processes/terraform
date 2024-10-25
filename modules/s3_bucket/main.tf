resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  policy = data.aws_iam_policy_document.bucket_policy.json
}
