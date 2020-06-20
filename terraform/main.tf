provider "aws" {
  region  = "eu-west-1"
  profile = "cygni"
}

locals {
  appname = "template-app"
}

module "FE" {
  source  = "./frontend"
  appname = local.appname
}

module "BE" {
  source  = "./backend"
  appname = local.appname
}
