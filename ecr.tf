resource "aws_ecr_repository" "anomaly_detection_repository" {
  name = "${local.name_prefix}-anomaly-detection-repository"
}
