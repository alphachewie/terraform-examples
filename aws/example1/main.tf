resource "aws_vpc" "amazing_vpc" {
  # Mandatory settings
  cidr_block = "10.0.0.0/16"
  # Optional settings
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  lifecycle {
    create_before_destroy = true
  }
  tags = "${
    map(
      "Name", "my-normal-vpc"
    )
  }"
}
