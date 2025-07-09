output "cluster_name" {
  value = data.aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_arn" {
  value = data.aws_eks_cluster.cluster.arn
}

