# Create a VPC to launch build instances into
locals {
  main-vpc-name = "${var.eks_cluster_name}-vpc"
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  lifecycle {
    create_before_destroy = true
  }

  tags = "${
    map(
     "Name", "${local.main-vpc-name}",
     "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
    )
  }"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "main-vpc-internet-gateway" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags {
    Name = "${local.main-vpc-name}-igw"
  }
}

# Create dhcp option setup
resource "aws_vpc_dhcp_options" "main-vpc-dhcp-options" {
  domain_name         = "${var.cluster_region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "${local.main-vpc-name}-dhcp-opts"
  }
}
