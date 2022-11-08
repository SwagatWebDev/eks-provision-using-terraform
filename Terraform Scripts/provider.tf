provider "aws" {
    profile = "terraform",
    region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # optional
      version = "~> 3.0"
     }
   }
}
