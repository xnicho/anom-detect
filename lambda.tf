resource "aws_lambda_function" "anomaly_detection_lambda" {
  depends_on    = [aws_sagemaker_endpoint_configuration.anomaly_detection_endpoint_config]
  function_name = "anomalyDetectionLambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_execution_role.arn

  environment {
    variables = {
      SAGEMAKER_ENDPOINT = aws_sagemaker_endpoint.anomaly_detection_endpoint.name
    }
  }

  s3_bucket = aws_s3_bucket.anom_detect_logs.id
  s3_key    = "lambda_function.zip"
}

resource "aws_lambda_event_source_mapping" "s3_event" {
  event_source_arn  = aws_s3_bucket.anom_detect_logs.arn
  function_name     = aws_lambda_function.anomaly_detection_lambda.arn
  starting_position = "LATEST"
}
