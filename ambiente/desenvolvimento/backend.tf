terraform {
  backend "s3" {
    bucket = "terraformautoscaling-state"
    key    = "terraformDev/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
  }
}
