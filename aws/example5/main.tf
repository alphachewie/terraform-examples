module "postgres" {
  source = "./modules/aurora-postgres"

  name = "first"
  db_identifier = "awesome_db1"

}

module "postgres" {
  source = "./modules/aurora-postgres"

  name = "second"
  db_identifier = "awesome_db2"

}

module "mysql" {
  source = "./modules/aurora-mysql"

  name = "first"
  db_identifier = "average_db1"

  vpc_name = "my-awesome-vpc"
  db_username = "dbuser"
  db_password = "dbpass"
  sec_grp_rds = ""
  subnets = ""
}