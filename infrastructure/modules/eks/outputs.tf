output "cluster_name" {
    value = aws_eks_cluster.cluster.name
}

output "issuer" {
    value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}