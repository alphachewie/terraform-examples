variable "cidr_block" {
  description = "The network definition of the VPC"
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "enable_dns_support" {}

variable "enable_dns_hostnames" {}