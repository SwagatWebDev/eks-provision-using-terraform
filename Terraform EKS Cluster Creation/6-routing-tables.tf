# A Route table contains a set of rules, called routes, that are used to determine where 
# network traffic from your subnet or gateway is directed.

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    # The CIDR block of the route.
    cidr_block = "10.0.1.0/24"
    # Directed the traffic to the Internet gateway 
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public"
  }
}