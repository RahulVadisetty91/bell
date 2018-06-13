module "util"{
    source = "../util"
}

module "ec2_mod"{
    source = "../ec2_module"

    ec2_names = "${var.ec2_names}"
    ec2_zones = "${var.ec2_zones}"
}

resource "null_resource" "cluster" {
    count = "${length(var.ec2_names)}"

    triggers {
        volume_attachment = "${join(",", aws_volume_attachment.attach.*.id)}"
    }

    connection {
        type = "ssh"
        user = "${var.USER}"
        password = "${var.PASSWORD}"
        host = "${element(module.ec2_mod.ec2_ips, count.index)}"
    }

    provisioner "remote-exec" {
        inline = [
            "echo changing permissions",
            "sudo -u root chmod 777 /app"
        ]
    }
}

resource "aws_ebs_volume" "disk" {
    count = "${length(var.ec2_names)}"
    availability_zone = "us-east-1a"
    type           =   "${module.util.volume_type}"
    size           =   "${module.util.volume_size}"
}

resource "aws_volume_attachment" "attach" {
    count = "${length(var.ec2_names)}"
    device_name = "/dev/sda2"
    volume_id = "${element(aws_ebs_volume.disk.*.id, count.index)}"
    instance_id = "${element(module.ec2_mod.ec2_ids, count.index)}"
    skip_destroy = true
}