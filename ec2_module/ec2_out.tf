output "ec2_ids"{
    value = "${aws_instance.instances.*.id}"
}

output "ec2_ips"{
    value = "${aws_instance.instances.*.private_ip}"
}