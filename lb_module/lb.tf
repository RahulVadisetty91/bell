module "util"{
    source = "../util"
}

resource "aws_lb" "elb" {

    count = "${length(var.lb_names)}"
    name = "${element(var.lb_names, count.index)}"
    subnets = ["${module.util.subnet_ids[format("%s%s", var.lb_zones[element(var.lb_names, count.index)], "1")]}",
    "${module.util.subnet_ids[format("%s%s", var.lb_zones[element(var.lb_names, count.index)], "2")]}",
    "${module.util.subnet_ids[format("%s%s", var.lb_zones[element(var.lb_names, count.index)], "3")]}",
    "${module.util.subnet_ids[format("%s%s", var.lb_zones[element(var.lb_names, count.index)], "4")]}"]
    security_groups = "${module.util.security_groups[var.lb_zones[element(var.lb_names, count.index)]]}"
    internal = "${module.util.elb_is_internal}"

    enable_deletion_protection = true
    
    tags {
        Name = "${element(var.lb_names, count.index)}"
        Owner = "${module.util.owner}"
        Environment = "${module.util.env}"
        Project = "${module.util.project}"
    }
}
