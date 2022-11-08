resource "aws_vpc" "main" {
  # The CIDR block for the vpc. he IPv4 CIDR block for the VPC.
  # CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length.
  cidr_block       = "10.0.0.0/16"

  # Makes your instances shared on the host.
  instance_tenancy = "default"

  # Required for EKS. Enable/disable DNS support in the VPC.
  # A boolean flag to enable/disable DNS support in the VPC. Defaults to true.
  enable_dns_support = true

  # Required for EKS. Enable/disable DNS hostnames support in the VPC.
  # A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.
  enable_dns_hostnames = true

  # Enable/disable ClassicLink DNS Support for the VPC
  enable_classic_dns_support = false

  # Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length
  assign_generated_ipv6_cidr_block = false;

  # A map of tags to assign to the resources.
  tags = {
    Name = "main"
  }
}

output "vpc_id" {
    value = aws_vpc.main.id
    description = "VPC id."
    # Setting an output values as sensitive prevents Terraform from showing its value in plan and apply
    sensitive = false
}
