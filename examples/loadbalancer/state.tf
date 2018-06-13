terraform {
  backend "s3" {
    bucket = "bellese-terraform-state"
    region = "us-east-1"
  }
}