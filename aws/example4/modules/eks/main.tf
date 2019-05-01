resource "aws_iam_role" "amazing_cluster_role" {
  assume_role_policy = ""
}

resource "aws_eks_cluster" "amazing_cluster" {
  name = "${var.eks_cluster_name}"
  role_arn = "${aws_iam_role.amazing_cluster_role.arn}"

  enabled_cluster_log_types = ["api", "audit"]
  "vpc_config" {
    subnet_ids = ["${var.subnet_id}"]
  }
}

output "endpoint" {
  value = "${aws_eks_cluster.amazing_cluster.endpoint}"
}