output "iam_instance_profile" {value = "EC2-Hostname"}
output "iam_S3_Redshift_profile" {value = "bellese-kafka-pr-data-Role"}

output "volume_type" {value = "gp2"}

output "volume_size" {value = "80"}

output "instance_type" {value = "m4.large"}

output "instance_type_db" {value = "db.m4.large"}

output "ami_id" {value = "ami-e402d49e"}

output "subnet_ids"{
  value = {
    "app1" = "subnet-93af76bf"
    "app2" = "subnet-ffa93cb7"
    "app3" = "subnet-552bfc0f"
    "app4" = "subnet-901821f5"
    "data1" = "subnet-5eae7772"
    "data2" = "subnet-87a83dcf"
    "data3" = "subnet-892dfad3"
    "data4" = "subnet-c6271ea3"
    "mgt1" = "subnet-88a178a4"
    "mgt2" = "subnet-92af3ada"
    "mgt3" = "subnet-992ef9c3"
    "mgt4" = "subnet-d6261fb3"
    "web1" = "subnet-5fae7773"
    "web2" = "subnet-74ab3e3c"
    "web3" = "subnet-4a2bfc10"
    "web4" = "subnet-d4261fb1"
  }
}

output "owner"{value = "Bellese"}

output "env"{value = "SBX"}

output "project"{value="Hcqis"}

# reconfigurable script to add LB

output "elb_name" {value="Hqr-lb"}

output "elb_is_internal" {
  description = "Determines if the ELB is internal or not"
  value = "true"
  // Defaults to false, which results in an external IP for the ELB
}

# Configuring Variables for DB

output "allocated_storage" {
  value = "32"
}

output "engine_version" {
  value = "9.6.5"
}

output "storage_type" {
  value = "gp2"
}

output "database_identifier" {
  
  value = "postgres-sonarcube"
}

output "database_name" {
  value = "postgressql"
}

output "database_port" {
  value = "5432"
}


#variable "multi_availability_zone" {
#  default = false
#}

output "storage_encrypted" {
  value = "false"
}

output "parameter_group" {
  value = "default.postgres9.6"
}


