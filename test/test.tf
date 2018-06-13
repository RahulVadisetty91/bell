module "ebs_mod"{
    source = "../ebs_module"

    ec2_names = "${var.names}"
    ec2_zones = "${var.zones}"
    USER = "${var.USER}"
    PASSWORD = "${var.PASSWORD}"
}

module "ec2_mod"{
    source = "../ec2_module"

    ec2_names = "${var.names}"
    ec2_zones = "${var.zones}"
}