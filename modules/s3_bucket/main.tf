
module "s3_bucket_module" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  bucket  = var.bucket_name
  acl     = "private"
  attach_policy = true
  policy  = data.aws_iam_policy_document.bucket_policy.json

  versioning = {
    enabled = true
  }
}
