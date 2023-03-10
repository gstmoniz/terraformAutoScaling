terraform {
  backend "s3" {
    bucket = "terraformautoscaling-state"
    key    = "terraformProd/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
  }
}
