# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# To Provide internet access for your services we need to have internet gateway in your VPC.
# It will be used as a default route for in public subnet.
# Internet Gateway is the Horizontal scaled, redudant and highly available VPC component 
# that allows communication to your VPC and the Internet. 
resource "aws_internet_gateway" "main" {
    # The VPC ID to create in, here we are providing id by taking reference from aws_vpc.main
    vpc_id = aws_vpc.main.id

    # A map of tags to assign to the resource
    tags = {
        Name = "main"
    }
}