
output "endpoint" {
  description = "Endpoint of the cluster"
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  description = "Kubeconfig file of the infrastructure"
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "aws_load_balancer_controller_role_arn" {
  description = "Load balancer controller ARN"
  value = aws_iam_role.aws_load_balancer_controller.arn
}