variable "eks_cluster_name" {
  description = "cluster name"
}

variable "eks_cluster_version" {
  description = "cluster version"
}

variable "eks_certificate_authority" {
  description = "eks certificate authority"
}

variable "eks_endpoint" {
  description = "eks cluster endpoint"
}

variable "iam_instance_profile" {
  description = "eks instance profile name"
}

variable "security_group_node" {
  description = "eks security group name"
}

variable "subnets" {
  type = "list"
}

variable "instance_class" {
  description = "Node instance type"
}

variable "autoscale_group_size_min" {
  description = "The minimum size of the autoscaling group"
}

variable "autoscale_group_size_desired" {
  description = "The desired size of the autoscaling group"
}

variable "autoscale_group_size_max" {
  description = "The maximum size of the autoscaling group"
}
