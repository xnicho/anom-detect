resource "aws_s3_bucket" "anom_detect_logs" {
  bucket = "${local.name_prefix}-logs-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_at_rest" {
  bucket = aws_s3_bucket.anom_detect_logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.master_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "anom_detect_logs_policy" {
  bucket = aws_s3_bucket.anom_detect_logs.id
  policy = data.aws_iam_policy_document.anom_detect_logs_policy_document.json
}

data "aws_iam_policy_document" "anom_detect_logs_policy_document" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.anom_detect_logs.arn,
      "${aws_s3_bucket.anom_detect_logs.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid    = "GetBucketACL"
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.anom_detect_logs.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid    = "S3PutObject"
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.anom_detect_logs.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
