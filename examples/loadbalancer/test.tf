module "lb_mod"{
    source = "../../lb_module"

    lb_names = "${var.lb_names}"
    lb_zones = "${var.lb_zones}"
}