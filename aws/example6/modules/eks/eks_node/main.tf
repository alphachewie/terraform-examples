#
# Worker autoscale
#
data "aws_ami" "eks-worker-ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html

data "template_file" "user-data" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    eks_certificate_authority = "${var.eks_certificate_authority}"
    eks_endpoint              = "${var.eks_endpoint}"
    eks_cluster_name          = "${var.eks_cluster_name}"
    aws_region_current_name   = "${data.aws_region.current.name}"
    stack_info                = "${var.eks_cluster_name}"
  }
}

resource "aws_launch_configuration" "eks-worker-launch-config" {
  associate_public_ip_address = true
  iam_instance_profile        = "${var.iam_instance_profile}"
  image_id                    = "${data.aws_ami.eks-worker-ami.id}"
  instance_type               = "${var.instance_class}"
  name_prefix                 = "${var.eks_cluster_name}-launch-config"
  security_groups             = ["${var.security_group_node}"]
  user_data                   = "${data.template_file.user-data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

#
# Actual group
#
resource "aws_autoscaling_group" "eks-worker-autoscaling-group" {
  desired_capacity     = "${var.autoscale_group_size_desired}"
  launch_configuration = "${aws_launch_configuration.eks-worker-launch-config.id}"
  max_size             = "${var.autoscale_group_size_max}"
  min_size             = "${var.autoscale_group_size_min}"
  name                 = "${var.eks_cluster_name}-eks-auto"
  vpc_zone_identifier  = ["${var.subnets}"]

  tag {
    key                 = "Name"
    value               = "${var.eks_cluster_name}-eks-auto"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.eks_cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = ""
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.eks_cluster_name}"
    value               = ""
    propagate_at_launch = true
  }
}
