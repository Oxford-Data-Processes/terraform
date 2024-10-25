module "s3_bucket_module" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  bucket  = "${var.project}-bucket-${var.aws_account_id}"
  acl     = "private"

  versioning = {
    enabled = true
  }
}