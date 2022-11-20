# Step-1: Creating Role that will be attached to EKS. Attach an IAM Policy 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
resource "aws_iam_role" "eks_cluster" {

  # The name of the role
  name = "eks-cluster"
  
  # The Role that Amazon EKS will be use to create AWS resources for kubernetes cluster.
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Step-2: Attach one Policy
resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {

  # The ARN of the Policy you want to apply 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  # The role where the policy should be apply to
  role       = aws_iam_role.eks_cluster.name
}

# Step-3: EKS Cluster Creation
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster

resource "aws_eks_cluster" "eks" {

  # Name of the cluster.
  name     = "eks"

  # we just need to attach the role which has policy associated.
  # The Amazon Resource Name(ARN) of the IAM role that provides permission for
  # the kubernetes control plane to make calls to AWS API operation in your behalf.
  role_arn = aws_iam_role.eks_cluster.arn

  # Desired Kubernetes master version
  version = "1.18"

  # VPC Block with Networking parameters
  vpc_config {

    # Indicates whether or not the Amazon EKS private API server endpoint is enabled
    endpoint_private_access = false

    # Indicates whether or not the Amazon EKS public API server endpoint is enabled
    endpoint_public_access = true

    # Must be in at least two different availablity zones
    subnet_ids = [
      aws_subnet.public-1.id,
      aws_subnet.public-2.id,
      aws_subnet.private-1.id,
      aws_subnet.private-2.id
    ]
  }


  # Ensure that IAM Role Permission are created before and deleted after EKS Cluster Creation
  # Otherwise, EKS will not able to properly delete EKS managed EC@ Infrastructure.

  # Since we are not using directly through our resouces we need to explictly declare it 
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
    ]
}