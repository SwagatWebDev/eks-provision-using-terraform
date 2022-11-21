# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# To meet EKS requirement, we need to have two public and two private subnet in different AZ.
# We need to create appropiate subnet docs that EKS manage Kubernetes Cluster can discover
# and create Public and Private Load Balancer.

# Public and private subnets - This VPC has two public and two private subnets. 
# One public and one private subnet are deployed to the same Availability Zone. 
# The other public and private subnets are deployed to a second Availability Zone in the 
# same Region. This is recommend option for all production deployments. 
# This option allows you to deploy your nodes to private subnets and allows Kubernetes 
# to deploy load balancers to the public subnets that can load balance traffic to pods 
# running on nodes in the private subnets. 

# Each Kubernetes worker will get a public IP
# Most of the time, you would use private subnets, for instances, groups, and create public load 
# balancer in public subnets
resource "aws_subnet" "public-1" {
  # The VPC ID.
  vpc_id                  = aws_vpc.main.id
  # The CIDR block for the subnet. Here we need to define how many 
  # IP addresses we need to allocate. 
  cidr_block              = "10.0.0.0/19"
  # The AZ for the subnet.
  availability_zone       = "us-east-2a"
  # Required for EKS. Every new Instances that will be deployed in the public subnet will 
  # automatically gets the public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    # Name of the subnet.
    "Name"                       = "public-1"
    # It will allow the EKS Cluster to discover the above subnet and use it.
    "kubernetes.io/cluster/demo" = "owned"
    # This block is mandatory if you want to deploy public load balancers.
    # When you create Kubernetes service type of your load balancer and you want to create
    # public load balancer. This tags will be use by EKS to discover those subnets and
    # it will place those load balancer in those subnets 
    "kubernetes.io/role/elb"     = "1"
    
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.main.id
  # The next CIDR block for the subnet. Here we need to define the next IP addresses of 10.0.64.0/19
  cidr_block              = "10.0.32.0/19"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-2"
    "kubernetes.io/cluster/demo" = "owned"
    "kubernetes.io/role/elb"     = "1"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.64.0/19"
  availability_zone = "us-east-2a"

  tags = {
    "Name"                            = "private-1"
    # This Internal ELB will allow EKS Cluster to deploy private load balancer in the ablove subnet.
    # If we don't define this EKS will not able to create the Load Balancers.
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.96.0/19"
  availability_zone = "us-east-2b"

  tags = {
    "Name"                            = "private-2"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}
