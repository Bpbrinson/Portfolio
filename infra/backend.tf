terraform {
  backend "s3" {
    bucket         = "portfolio-state-bucket-7598"
    key            = "ecs/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "portfolio-state-locks"
  }
}
