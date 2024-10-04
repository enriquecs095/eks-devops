resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks.name
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = local.subnets_eks
  }
  version=var.eks.version
  depends_on = [
    aws_iam_role_policy_attachment.Amazon_EKS_cluster_policy,
    aws_iam_role_policy_attachment.Amazon_EKS_VPC_resource_controller,
  ]
  
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster.version}/amazon-linux-2/recommended/release_version"
}


resource "aws_eks_node_group" "eks_cluster_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.eks.node_group.node_group_name

  node_role_arn   = aws_iam_role.eks_worker_node_role.arn
  subnet_ids      = local.subnets_eks
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)

  instance_types = var.eks.node_group.instance_types

  remote_access {
     ec2_ssh_key = var.eks.node_group.remote_access_key
     source_security_group_ids = local.security_groups_eks
  }

  scaling_config {
    desired_size = var.eks.node_group.scaling_config_desired_size
    max_size     = var.eks.node_group.scaling_config_max_size
    min_size     = var.eks.node_group.scaling_config_min_size
  }

  capacity_type = var.eks.node_group.capacity_type
  ami_type = var.eks.node_group.ami_type

  update_config {
    max_unavailable = var.eks.node_group.update_config_max_unavailable
  }

  depends_on = [
    aws_iam_role_policy_attachment.Amazon_EKS_worker_node_policy,
    aws_iam_role_policy_attachment.Amazon_EKS_CNI_policy,
    aws_iam_role_policy_attachment.Amazon_EC2_container_registry_readonly,
  ]
}
