module "util"{
    source = "../util"
}

resource "aws_instance" "instances" {
    ami = "${module.util.ami_id}"
    count = "${length(var.ec2_names)}"
    subnet_id = "${module.util.subnet_ids[var.ec2_zones[element(var.ec2_names, count.index)]]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"

    tags {
        Name = "${element(var.ec2_names, count.index)}"
        Owner = "${module.util.owner}"
        Environment = "${module.util.env}"
        Project = "${module.util.project}"
        Zone = "${var.ec2_zones[element(var.ec2_names, count.index)]}"
    }

    security_groups = "${module.util.security_groups[module.util.zone_collection[var.ec2_zones[element(var.ec2_names, count.index)]]]}"
    user_data = "${file("${module.util.user_data_path}")}"

    lifecycle {
        ignore_changes = [
            "tags.HCQISName",
            "tags.ADO",
            "tags.APPLICATION",
            "tags.DNS",
            "tags.DeployStatus",
            "tags.ENVIRONMENT",
            "tags.IPA",
            "tags.TIER",
            "tags.cpm backup",
            "tags.%"
            ]
    }
}