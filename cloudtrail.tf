resource "aws_cloudtrail" "anom_detect_cloudtrail" {
  name                          = "${var.environment}-${local.project_name}--cloudtrail"
  s3_bucket_name                = aws_s3_bucket.anom_detect_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
}