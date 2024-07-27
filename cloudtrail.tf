resource "aws_cloudtrail" "anom_detect_cloudtrail" {
  name                          = "${local.name_prefix}-cloudtrail"
  depends_on                    = [aws_s3_bucket_policy.anom_detect_logs_policy]
  s3_bucket_name                = aws_s3_bucket.anom_detect_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
}