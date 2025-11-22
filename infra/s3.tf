resource "aws_s3_bucket" "portfolio_lb_logs" {
  bucket = "portfolio-lb-logs-bucket-7598"

  tags = {
    Name = "portfolio-lb-logs-bucket"
  }
  
}