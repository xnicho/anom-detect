resource "aws_kms_key" "master_key" {
  description             = "Primary encryption key"
  deletion_window_in_days = 10
}