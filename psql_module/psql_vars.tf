variable "psql_names" {type = "list"}

variable "vpc_id" {}

variable "database_username" {}

variable "database_password" {}

variable "snapshot_identifier" {
  default = ""
}

variable "backup_retention_period" {
 default = "30"
}

variable "backup_window" {
  # 12:00AM-12:30AM ET
  default = "04:00-04:30"
}

variable "maintenance_window" {
  # SUN 12:30AM-01:30AM ET
  default = "sun:04:30-sun:05:30"
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "final_snapshot_identifier" {
  default = "terraform-aws-postgresql-rds-snapshot"
}

variable "skip_final_snapshot" {
 default = false
}

variable "copy_tags_to_snapshot" {
 default = false
}