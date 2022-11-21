# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip 
# Here we are creating our first Elastic IP Address. This resource allocates the public static IP
# address in AWS. Here one requirement is that the Internet Gateway must present in the VPC
resource "aws_eip" "nat1" {
  # EIP may require IGW to exist prior to allocation.
  depends_on = [aws_internet_gateway.main]

}

# We are going to place one NAT Gateway in each AZ to make it highly available

resource "aws_eip" "nat2" {
  # EIP may require IGW to exist prior to allocation.
  depends_on = [aws_internet_gateway.main]

}
