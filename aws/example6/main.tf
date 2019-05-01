provider "aws" {
  region = "${var.target_region}"
}

module "vpc" {
  source = "./modules/network/vpc"

  eks_cluster_name = "${var.cluster_name}"
  cidr_block       = "${var.cidr_block}"
  cluster_region   = "${var.target_region}"
}

module "eks_iam_groups" {
  source           = "./modules/eks/eks_iam_roles"
  eks_cluster_name = "${var.cluster_name}"
}

module "eks_sec_grp" {
  source           = "./modules/eks/eks_sec_group"
  eks_cluster_name = "${var.cluster_name}"
  vpc_id           = "${module.vpc.vpc_id}"
}

module "eks_iam_roles" {
  source           = "./modules/eks/eks_iam_roles"
  eks_cluster_name = "${var.cluster_name}"
}

module "eks_subnets" {
  source = "./modules/network/subnet"

  eks_cluster_name = "${var.cluster_name}"
  vpc_cidr_block   = "${module.vpc.vpc_cidr_block}"
  vpc_id           = "${module.vpc.vpc_id}"
}

# Configure Routes
module "route" {
  source              = "./modules/network/route"
  eks_cluster_name    = "${var.cluster_name}"
  main_route_table_id = "${module.vpc.main_route_table_id}"
  gw_id               = "${module.vpc.gw_id}"

  subnets = [
    "${module.eks_subnets.subnets}",
  ]
}

module "eks_cluster" {
  source = "./modules/eks/eks_cluster"

  eks_cluster_name        = "${var.cluster_name}"
  eks_cluster_k8s_version = "${var.kubernetes_version}"
  iam_cluster_arn         = "${module.eks_iam_groups.iam_cluster_arn}"
  iam_node_arn            = "${module.eks_iam_groups.iam_node_arn}"
  security_group_cluster  = "${module.eks_sec_grp.security_group_cluster}"

  subnets = [
    "${module.eks_subnets.subnets}",
  ]
}

module "eks_node" {
  source                    = "./modules/eks/eks_node"
  eks_cluster_name          = "${var.cluster_name}"
  eks_cluster_version       = "${module.eks_cluster.eks_cluster_version}"
  eks_certificate_authority = "${module.eks_cluster.eks_certificate_authority}"
  eks_endpoint              = "${module.eks_cluster.eks_endpoint}"
  iam_instance_profile      = "${module.eks_iam_roles.iam_instance_profile}"
  security_group_node       = "${module.eks_sec_grp.security_group_node}"
  instance_class            = "${var.eks_cluster_node_instance_type}"

  autoscale_group_size_min     = "${var.node_autoscale_group_size_min}"
  autoscale_group_size_desired = "${var.node_autoscale_group_size_desired}"
  autoscale_group_size_max     = "${var.node_autoscale_group_size_max}"

  subnets = [
    "${module.eks_subnets.subnets}",
  ]
}

# Enable the cluster nodes
module "k8s_aws_auth" {
  source = "./modules/eks/k8s"

  eks_cluster_name = "${var.cluster_name}"

  eks_cluster_endpoint = "${module.eks_cluster.eks_endpoint}"
  eks_ca_cert_data = "${module.eks_cluster.eks_certificate_authority}"
  eks_node_role_id = "${module.eks_iam_roles.iam_node_arn}"
}
