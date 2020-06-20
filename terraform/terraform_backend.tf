terraform {
  backend "s3" {
    bucket  = "terraform-bucket-293847"
    key     = "question-report/test"
    region  = "eu-west-1"
    profile = "cygni"
  }
}
