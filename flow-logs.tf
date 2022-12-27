resource "aws_flow_log" "aws_flow_log" {
  log_destination      = aws_s3_bucket.s3-cloudtrail-bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.dev.id
}