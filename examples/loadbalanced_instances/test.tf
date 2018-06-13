module "ec2_mod"{
    source = "../../ec2_module"

    ec2_names = "${var.names}"
    ec2_zones = "${var.zones}"
}

# This currently makes the assumption that the apps run on port 80. If you want to change this, you will
# need to add the port variables to this module. Check the lb_target_module variables file for the vars
# needed to set the ports correctly
module "lb_target_mod"{
    source = "../../lb_target_module"

    vpc_id = "${var.vpc_id}"
    target_group_name = "${var.target_group_name}"
    load_balancer_arn = "${var.lb_arn}"
    instance_ids = "${module.ec2_mod.ec2_ids}"
}