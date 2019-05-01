resource "aws_rds_cluster" "aurora-cluster" {

  cluster_identifier = "${var.db_identifier}"
  engine = "postgresql"

  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.cluster-param-group.id}"
}

resource "aws_rds_cluster_instance" "aurora-cluster-instance" {
  cluster_identifier = "${aws_rds_cluster.aurora-cluster.cluster_identifier}"
  instance_class = "db.t2.medium"

  db_parameter_group_name = "${aws_db_parameter_group.instance-param-group.id}"
}

resource "aws_rds_cluster_parameter_group" "cluster-param-group" {
  family = "postgres"
}

resource "aws_db_parameter_group" "instance-param-group" {
  family = "postgres"

  parameter {
    name = "charset"
    value = "utf8"
  }
}
