output "security_group_cluster" {
  value = "${aws_security_group.eks-cluster-security-group.id}"
}

output "security_group_node" {
  value = "${aws_security_group.eks-node-security-group.id}"
}
