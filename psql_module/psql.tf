module "util" {
    source = "../util"
}

resource "aws_db_instance" "main_rds_instance" {

  allocated_storage          = "${module.util.allocated_storage}"
  engine                     = "postgres"
  engine_version             = "${module.util.engine_version}"
  identifier                 = "${module.util.database_identifier}"
  snapshot_identifier       = "${var.snapshot_identifier}"
  instance_class             = "${module.util.instance_type_db}"
  storage_type               = "${module.util.storage_type}"
  name                       = "${module.util.database_name}"
  username                   = "${var.database_username}"
  password                   = "${var.database_password}"
  backup_retention_period   = "${var.backup_retention_period}"
  backup_window             = "${var.backup_window}"
  maintenance_window        = "${var.maintenance_window}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  final_snapshot_identifier  = "${var.final_snapshot_identifier}"
  skip_final_snapshot        = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot      = "${var.copy_tags_to_snapshot}"
  #multi_az                   = "${module.util.multi_availability_zone}"
  port                        = "${module.util.database_port}"
  db_subnet_group_name        = "hqr-sbx-rds-subnet-group"
  vpc_security_group_ids      = "${module.util.security_groups["data"]}"
  #db_subnet_group_name       = "${module.util.subnet_group}"
  parameter_group_name        = "${module.util.parameter_group}"
  storage_encrypted           = "${module.util.storage_encrypted}"
  
  tags {
      Name = "${element(var.psql_names, count.index)}"
      Owner = "${module.util.owner}"
      Environment = "${module.util.env}"
      Project = "${module.util.project}"
    }
}

data "aws_db_snapshot" "db_snapshot" {
    most_recent = true
    db_instance_identifier = "${aws_db_instance.main_rds_instance.identifier}"
}