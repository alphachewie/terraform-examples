output "subnets" {
  value = ["${aws_subnet.pcs-subnet.*.id}"]
}
