resource "aws_db_subnet_group" "db_sub_gr" {
  description = "Central Manager DB subnet group"
  name        = "${var.db_identifier}-subnet-group"
  subnet_ids  = ["${var.subnets}"]

  tags {
    Name = "${var.db_identifier}-subnet-group"
  }
}

resource "aws_rds_cluster" "aurora-cluster" {

  cluster_identifier = "${var.db_identifier}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.cluster-param-group.id}"
  database_name           = "${var.db_identifier}"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.12"
  master_username         = "${var.db_username}"
  master_password         = "${var.db_password}"
  vpc_security_group_ids = [
    "${var.sec_grp_rds}",
  ]
  skip_final_snapshot = true
  storage_encrypted    = false
  db_subnet_group_name = "${aws_db_subnet_group.db_sub_gr.id}"
  apply_immediately = true

  tags {
    Name = "${var.db_identifier}-db-cluster"
    VPC = "${var.vpc_name}"
  }
}

resource "aws_rds_cluster_instance" "aurora-cluster-instance" {
  cluster_identifier = "${aws_rds_cluster.aurora-cluster.id}"
  instance_class = "db.t2.medium"
  db_parameter_group_name = "${aws_db_parameter_group.instance-param-group.name}"
  count                   = 1
  identifier              = "${var.db_identifier}-db-${count.index}"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.12"
  db_subnet_group_name    = "${aws_db_subnet_group.db_sub_gr.id}"
  publicly_accessible     = true
  apply_immediately       = true

  tags {
    Name = "${var.db_identifier}-db-${count.index}"
    VPC = "${var.vpc_name}"
  }
}

resource "aws_rds_cluster_parameter_group" "cluster-param-group" {
  family = "mysql"
}

resource "aws_db_parameter_group" "instance-param-group" {
  family = "mysql"

  parameter {
    name = "charset"
    value = "utf8"
  }
}

