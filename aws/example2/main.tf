resource "aws_vpc" "amazing_vpc" {
  # Mandatory settings
  cidr_block = "${var.cidr_block}"

  # Optional settings
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"

  instance_tenancy = "default"

  lifecycle {
    create_before_destroy = true
  }

  tags = "${
    map(
      "Name", "${var.vpc_name}"
    )
  }"
}