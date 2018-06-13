module "util"{
    source = "../util"
}

resource "aws_lb_target_group" "group" {
    port                 = "${var.target_group_port}"
    protocol             = "HTTP"
    vpc_id               = "${var.vpc_id}"
    health_check {
        path                = "${var.health_check_path}"
    }
    tags {
        Name = "${var.target_group_name}"
        Owner = "${module.util.owner}"
        Environment = "${module.util.env}"
        Project = "${module.util.project}"
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = "${var.load_balancer_arn}"
    port              = "${var.listener_port}"
    default_action {
       target_group_arn = "${aws_lb_target_group.group.arn}"
       type             = "forward"
    }
}

resource "aws_lb_target_group_attachment" "attach"{
    target_group_arn = "${aws_lb_target_group.group.arn}"
    target_id = "${element(var.instance_ids, count.index)}"
    port = "${var.app_port}"
    count = "${length(var.instance_ids)}"
}