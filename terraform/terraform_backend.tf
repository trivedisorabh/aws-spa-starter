terraform {
  backend "s3" {
    bucket  = "terraform-bucket-293847"
    key     = "template-app/test"
    region  = "eu-west-1"
    profile = "cygni"
  }
}
