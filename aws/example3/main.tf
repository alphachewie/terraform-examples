module "vpc1" {
  source = "./modules/base"
  name = "vpc1"  # needed for multiple module use

  cidr_block = "${var.vpc1_cidr_block}"
  vpc_name = "${var.vpc1_name}"
}

module "vpc2" {
  source = "./modules/base"
  name = "vpc2"

  cidr_block = "${var.vpc2_cidr_block}"
  vpc_name = "${var.vpc2_name}"
}

