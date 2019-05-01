output "iam_cluster_arn" {
  value = "${aws_iam_role.eks-cluster-iam-role.arn}"
}

output "iam_instance_profile" {
  value = "${aws_iam_instance_profile.eks-cluster-node-profile.name}"
}

output "iam_node_arn" {
  value = "${aws_iam_role.eks-cluster-node-role.arn}"
}
