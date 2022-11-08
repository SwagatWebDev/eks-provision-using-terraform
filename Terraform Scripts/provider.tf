provider "aws" {
    region = "us-east-2"
    access_key = "my-access-key"
    secret_key = "my-secret-key"
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
