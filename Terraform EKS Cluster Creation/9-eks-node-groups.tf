# Step-1: Here also we need to define the role first 
# Resource: aws_iam_role
resource "aws_iam_role" "nodes_general" {
  # The name of the role
  name = "eks-node-group-general"
  
  # The policy that grants an entity permission to assume the role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2
        # .amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Step-2: Here we need to attach 3 different policy to the Role
# Resource: aws_iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  # The ARN of the Policy you want to apply 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  # The role where the policy should be apply to
  role       = aws_iam_role.nodes_general.name
}

# This policy will defines assign IP addresses, describe tags and etc.
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  # The ARN of the Policy you want to apply 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  
  # The role where the policy should be apply to
  role       = aws_iam_role.nodes_general.name
}

# This policy will allow us to download the private images from our ECR Repository
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  # The ARN of the Policy you want to apply 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  # The role where the policy should be apply to
  role       = aws_iam_role.nodes_general.name
}

# Step-3: Creating Instance Group
# Resource: aws_eks_node_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
resource "aws_eks_node_group" "nodes-general" {
  # Name of the EKS Cluster.  
  cluster_name    = aws_eks_cluster.eks.name

  # Name of EKS node group
  node_group_name = "nodes-general"

  # ARN of the IAM Role that provides permission for the EKS Cluster 
  node_role_arn   = aws_iam_role.nodes_general.arn

  # We need to define the subnets. Here we are going to use only Private subnets to deploy
  # our worker node. 
  # Note: We only use Public subnet to deploy the load balancer.
  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id
  ]

  # Configuration block with scaling settings
  scaling_config {
    # Desired number of worker nodes 
    desired_size = 1

    # Maximum number of worker nodes
    max_size     = 1

    # Minimum number of worker nodes
    min_size     = 1
  }

  # Type of Amazon Machine Image (AMI) associated with EKS Node Group.(Optional Parameter)
  # Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type = "AL2_x86_64"

  # Type of capacity associated with EKS Node Group.
  # Valid values: ON_DEMAND, SPOT
  capacity_type  = "ON_DEMAND"

  # Disk Size in GiB for worker Nodes(for Production recomended 100GiB)
  disk_size = 20

  # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  force_update_version = false

  # List of instance types associated with EKS Node Group
  instance_types = ["t3.small"]

  labels = {
    role = "general"
  }

  # Kubernetes Version (optional)
  version = "1.18"

  # We need to define depends on block since we attaching 3 policies.
  # Since we are not using directly through our resouces we need to explictly declare it 
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
    ]