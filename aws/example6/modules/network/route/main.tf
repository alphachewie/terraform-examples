data "aws_availability_zones" "available" {}

resource "aws_route_table_association" "eks-route-table-association" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(var.subnets, count.index)}"
  route_table_id = "${var.main_route_table_id}"
}

resource "aws_default_route_table" "default-route" {
  default_route_table_id = "${var.main_route_table_id}"

  tags {
    Name = "${var.eks_cluster_name}-eks-route"
  }
}

# Internet access
resource "aws_route" "route_internet" {
  route_table_id         = "${var.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${var.gw_id}"
  depends_on             = ["aws_route_table_association.eks-route-table-association"]
}
