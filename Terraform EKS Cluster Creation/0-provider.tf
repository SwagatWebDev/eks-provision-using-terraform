# We need to create an AWS provider. It allows to interact with the many resources 
# supported by AWS, such as VPC, EC2, EKS, and many others. You must configure the provider 
# with the proper credentials before using it. 
provider "aws" {
    region = "us-east-2"
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
