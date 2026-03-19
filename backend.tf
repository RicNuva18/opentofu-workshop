terraform {
  backend "s3" {
    bucket         = "test-cncf-ric-19032026"
    key            = "prod/ec2/terraform.tfstate" 
    region         = "us-east-1"
  }
}