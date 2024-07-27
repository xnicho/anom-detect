
resource "aws_sagemaker_model" "anomaly_detection_model" {
  name               = "${local.name_prefix}-anomaly-detection-model"
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn

  primary_container {
    image          = "123456789012.dkr.ecr.ap-southeast-2.amazonaws.com/anomaly-detection:latest"
    model_data_url = "s3://${aws_s3_bucket.sagemaker_bucket.bucket}/model.tar.gz"
  }
}

resource "aws_sagemaker_endpoint" "anomaly_detection_endpoint" {
  name                 = "${local.name_prefix}-anomaly-detection-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.anomaly_detection_endpoint_config.name
}

resource "aws_sagemaker_endpoint_configuration" "anomaly_detection_endpoint_config" {
  name = "${local.name_prefix}-anomaly-detection-endpoint-config"

  production_variants {
    variant_name           = "AllTraffic"
    model_name             = aws_sagemaker_model.anomaly_detection_model.name
    initial_instance_count = 1
    instance_type          = "ml.t2.medium"
  }
}