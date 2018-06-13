module "ec2_mod" {
    source = "../ec2_module"

    ec2_names = "${var.names}"
    ec2_zones = "${var.zones}"
}