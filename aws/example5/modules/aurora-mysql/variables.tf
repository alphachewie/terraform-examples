variable "db_identifier" {
  description = "THe identifier for the databse"
}

variable "subnets" {
  type = "list"
}

variable "db_username" {}

variable "db_password" {}

variable "sec_grp_rds" {}

variable "vpc_name" {}