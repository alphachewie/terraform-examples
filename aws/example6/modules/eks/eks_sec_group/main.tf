resource "aws_security_group" "eks-cluster-security-group" {
  name        = "${var.eks_cluster_name}-eks-sec-group"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.eks_cluster_name}-eks-sec-group"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
/*
resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
  cidr_blocks       = ["A.B.C.D/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks-cluster-security-group.id}"
  to_port           = 443
  type              = "ingress"
}
*/

#
# Worker nodes Security Groups
#
resource "aws_security_group" "eks-node-security-group" {
  name        = "${var.eks_cluster_name}-eks-node-sec-group"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "${var.eks_cluster_name}-eks-node-sec-group",
     "kubernetes.io/cluster/${var.eks_cluster_name}", "owned"

    )
  }"
}

resource "aws_security_group_rule" "eks-node-ingress-internal" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks-node-security-group.id}"
  source_security_group_id = "${aws_security_group.eks-node-security-group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-node-security-group.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-security-group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

#
# Access from Nodes to Masters
#
resource "aws_security_group_rule" "eks-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-cluster-security-group.id}"
  source_security_group_id = "${aws_security_group.eks-node-security-group.id}"
  to_port                  = 443
  type                     = "ingress"
}
