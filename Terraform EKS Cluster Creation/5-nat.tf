# NAT Gateway is used to eanable instances in private subnets to connect to the Internet
# e.g for software installation or updates. Also we need to allocate a public static IP address 
# for those NAT Gateways. For that purpose we will use another AWS service called Elastic IP addresses

resource "aws_nat_gateway" "gw1" {
  # The Allocation ID of the Elastic IP address for the gateway.
  # Its the public IP address that NAT gateways works in the way that translates the private
  # IP address to public IP address to get Internete access.
  # Bellow is the reference of the Elastic IP address what we just created before.
  allocation_id = aws_eip.nat1.id

  # This subnet id has to be one of the public subnets.
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "nat-1"
  }
}

resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public-2.id

  tags = {
    Name = "nat-2"
  }
}
