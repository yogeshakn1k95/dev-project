terraform {
  backend "s3" {
    bucket         = "devops-tf-state-bucket-123"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}
