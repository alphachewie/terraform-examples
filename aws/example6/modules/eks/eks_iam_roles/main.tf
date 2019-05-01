#
# Cluster roles and attachments
#
resource "aws_iam_role" "eks-cluster-iam-role" {
  name = "${var.eks_cluster_name}-iam-role"

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

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks-cluster-iam-role.name}"
}

resource "aws_iam_role_policy_attachment" "eks-service-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks-cluster-iam-role.name}"
}

#
# Role policies
#
resource "aws_iam_policy" "eks-cluster-node-autoscaler-policy" {
  name = "${var.eks_cluster_name}-cluster-autoscaler"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

#
# Node roles and attachments
#
resource "aws_iam_role" "eks-cluster-node-role" {
  name = "${var.eks_cluster_name}-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks-cluster-node-role.name}"
}

resource "aws_iam_role_policy_attachment" "eks-cni-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks-cluster-node-role.name}"
}

resource "aws_iam_role_policy_attachment" "eks-ec2-container-registry-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks-cluster-node-role.name}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-node-autoscaler-policy" {
  policy_arn = "${aws_iam_policy.eks-cluster-node-autoscaler-policy.arn}"
  role       = "${aws_iam_role.eks-cluster-node-role.name}"
}

resource "aws_iam_instance_profile" "eks-cluster-node-profile" {
  name = "${var.eks_cluster_name}-node-profile"
  role = "${aws_iam_role.eks-cluster-node-role.name}"
}
