output "vpc_id" {
  value = "${aws_vpc.main_vpc.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.main_vpc.cidr_block}"
}

output "gw_id" {
  value = "${aws_internet_gateway.main-vpc-internet-gateway.id}"
}

output "main_route_table_id" {
  value = "${aws_vpc.main_vpc.main_route_table_id}"
}

output "vpc_dhcp_id" {
  value = "${aws_vpc_dhcp_options.main-vpc-dhcp-options.id}"
}

output "vpc_name" {
  value = "${local.main-vpc-name}"
}
