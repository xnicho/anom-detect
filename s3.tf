resource "aws_s3_bucket" "anom_detect_logs" {
  bucket = "${locals.project_name}-${var.environment}"
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

resource "aws_s3_bucket_policy" "enyption_in_transit" {
  bucket = aws_s3_bucket.anom_detect_logs.id
  policy = data.aws_iam_policy_document.encrypt_in_tranit.json
}

data "aws_iam_policy_document" "encrypt_in_tranit" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.anom_detect_bucket.arn,
      "${aws_s3_bucket.anom_detect_bucket.arn}/*",
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
}