module "util" {
    source = "../util"
}


resource "aws_security_group" "web_lb" {
    name        = "SG-DEV-Web-LB"
    description = "Dev Web Load Balancer Security Group"
    vpc_id      = "vpc-c270a4bb"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = ["sg-d2b38eac"]
      }
}

# Zuul Load Balancers
resource "aws_security_group" "lb-zuul-app" {
     name = "LB-Zuul-App"
     description = "Load Balancer for Zuul App Zone"
     vpc_id      = "vpc-c270a4bb"

     ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = ["sg-d2b38eac"]
      }

     tags {
        Name = "LB-Zuul-App"
      }
}

resource "aws_security_group" "lb-zuul-data" {
     name = "LB-Zuul-Data"
     description = "Load Balancer for Zuul Data Zone" 
     vpc_id      = "vpc-c270a4bb"

     tags {
        Name = "LB-Zuul-Data"
      }
}

# Zuul Hosts
resource "aws_security_group" "zuul-app" {
     name = "Zuul-App"
     description = "Zuul App Zone"
     vpc_id      = "vpc-c270a4bb"

     ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        security_groups = ["${aws_security_group.lb-zuul-app.id}"]
      }

      ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        security_groups = ["sg-01ad907f"]
      }

     tags {
        Name = "Zuul-App"
      }
}

resource "aws_security_group" "zuul-data" {
     name = "Zuul-Data"
     description = "Zuul Data Zone" 
     vpc_id      = "vpc-c270a4bb"

     ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        security_groups = ["${aws_security_group.lb-zuul-data.id}"]
      }

      ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        security_groups = ["sg-01ad907f"]
      }

     tags {
        Name = "Zuul-Data"
      }
}

#etcd Hosts
resource "aws_security_group" "etcd" {
     name = "etcd"
     description = "etcd Hosts"
     vpc_id      = "vpc-c270a4bb"

      ingress {
        from_port   = 2379
        to_port     = 2379
        protocol    = "tcp"
        security_groups = ["sg-01ad907f"]
      }

      ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = ["sg-01ad907f"]
      }

     tags {
        Name = "etcd"
      }
}

# Microservice Host Load Balancers
resource "aws_security_group" "lb-microservice-host-data" {
     name = "LB-Microservice-Host-Data"
     description = "Load Balancer for Data Microservice Hosts"
     vpc_id      = "vpc-c270a4bb"

     ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = ["${aws_security_group.lb-zuul-data.id}"]
      }

     tags {
        Name = "LB-Microservice-Host-Data"
      }
}

resource "aws_security_group" "lb-microservice-host-app" {
     name = "LB-Microservice-Host-App"
     description = "Load Balancer for App Microservice Hosts"
     vpc_id      = "vpc-c270a4bb"

     ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = ["${aws_security_group.lb-zuul-app.id}"]
      }

     tags {
        Name = "LB-Microservice-Host-App"
      }
}

# Microservice Hosts
resource "aws_security_group" "microservice-host-data" {
     name = "Microservice-Host-Data"
     description = "Data Microservice Hosts" 
     vpc_id      = "vpc-c270a4bb"

     ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        security_groups = ["${aws_security_group.lb-microservice-host-data.id}"]
      }

      ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        security_groups = ["sg-01ad907f"]
      }

     tags {
        Name = "Microservice-Host-Data"
      }
}

resource "aws_security_group" "microservice-host-app" {
     name = "Microservice-Host-App"
     description = "App Microservice Hosts" 
     vpc_id      = "vpc-c270a4bb"

     ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        security_groups = ["${aws_security_group.lb-microservice-host-app.id}"]
      }

      ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        security_groups = ["sg-01ad907f"]
      }

     tags {
        Name = "Microservice-Host-App"
      }
}


# Additional, cyclically-dependent security groups for Microservice -> Zuul communications

resource "aws_security_group_rule" "microservice-app-zuul-app-lb" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.microservice-host-app.id}"

  security_group_id = "${aws_security_group.lb-zuul-app.id}"
}

resource "aws_security_group_rule" "microservice-app-zuul-data-lb" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.microservice-host-app.id}"

  security_group_id = "${aws_security_group.lb-zuul-data.id}"
}

resource "aws_security_group_rule" "microservice-data-zuul-data-lb" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.microservice-host-data.id}"

  security_group_id = "${aws_security_group.lb-zuul-data.id}"
}


resource "aws_instance" "web_host_1" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["web1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["web_host_1"]}"

    tags {
        Name = "Web Host 1"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "WEB-AZ-1"
    }

    vpc_security_group_ids = ["sg-d2b38eac"]
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

resource "aws_instance" "web_host_2" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["web2"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["web_host_2"]}"

    tags {
        Name = "Web Host 2"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "WEB-AZ-2"
    }

    vpc_security_group_ids = ["sg-d2b38eac"]
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

resource "aws_instance" "app_host_1_1" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["app1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["app_host_1_1"]}"

    tags {
        Name = "App Host 1a"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "APP-AZ-1"
    }

    vpc_security_group_ids = ["${aws_security_group.microservice-host-app.id}"]
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

resource "aws_instance" "app_host_1_2" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["app1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["app_host_1_2"]}"

    tags {
        Name = "App Host 1b"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "APP-AZ-1"
    }

    vpc_security_group_ids = ["${aws_security_group.microservice-host-app.id}"]
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

resource "aws_instance" "app_host_2_1" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["app2"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["app_host_2_1"]}"

    tags {
        Name = "App Host 2a"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "APP-AZ-2"
    }

    vpc_security_group_ids = ["${aws_security_group.microservice-host-app.id}"]
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

resource "aws_instance" "app_host_2_2" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["app2"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["app_host_2_2"]}"

    tags {
        Name = "App Host 2b"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "APP-AZ-2"
    }

    vpc_security_group_ids = ["${aws_security_group.microservice-host-app.id}"]
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

resource "aws_instance" "data_host_1_1" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["data_host_1_1"]}"

    tags {
        Name = "Data Host 1a"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "DATA-AZ-1"
    }

    vpc_security_group_ids = ["${aws_security_group.microservice-host-data.id}"]
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

resource "aws_instance" "data_host_1_2" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["data_host_1_2"]}"

    tags {
        Name = "Data Host 1b"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "DATA-AZ-1"
    }

    vpc_security_group_ids = ["${aws_security_group.microservice-host-data.id}"]
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

resource "aws_instance" "data_host_2_1" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data2"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["data_host_2_1"]}"

    tags {
        Name = "Data Host 2a"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "DATA-AZ-2"
    }

    vpc_security_group_ids = ["${aws_security_group.microservice-host-data.id}"]
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

resource "aws_instance" "data_host_2_2" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data2"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["data_host_2_2"]}"

    tags {
        Name = "Data Host 2b"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "DATA-AZ-2"
    }

    vpc_security_group_ids = ["${aws_security_group.microservice-host-data.id}"]
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

resource "aws_instance" "zuul_app_1" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["app1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["zuul_app_1"]}"

    tags {
        Name = "Zuul App 1"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "APP-AZ-1"
    }

    vpc_security_group_ids = ["${aws_security_group.zuul-app.id}"]
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

resource "aws_instance" "zuul_app_2" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["app2"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["zuul_app_2"]}"

    tags {
        Name = "Zuul App 2"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "APP-AZ-2"
    }

    vpc_security_group_ids = ["${aws_security_group.zuul-app.id}"]
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

resource "aws_instance" "zuul_data_1" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["zuul_data_1"]}"

    tags {
        Name = "Zuul Data 1"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "DATA-AZ-1"
    }

    vpc_security_group_ids = ["${aws_security_group.zuul-data.id}"]
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

resource "aws_instance" "zuul_data_2" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data2"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["zuul_data_2"]}"

    tags {
        Name = "Zuul Data 2"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "DATA-AZ-2"
    }

    vpc_security_group_ids = ["${aws_security_group.zuul-data.id}"]
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

resource "aws_instance" "qarm_app" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["app1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["qarm_app"]}"

    tags {
        Name = "QARM App"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "APP-AZ-1"
    }

    vpc_security_group_ids = ["sg-01ad907f"]
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

resource "aws_instance" "qarm_data" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["qarm_data"]}"

    tags {
        Name = "QARM Data"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "Data-AZ-1"
    }

    vpc_security_group_ids = ["sg-01ad907f"]
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


resource "aws_instance" "etcd_1" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["etcd_1"]}"

    tags {
        Name = "ETCD 1"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "Data-AZ-1"
    }

    vpc_security_group_ids = ["${aws_security_group.etcd.id}"]
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

resource "aws_instance" "etcd_2" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data1"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["etcd_2"]}"

    tags {
        Name = "ETCD 2"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "Data-AZ-1"
    }

    vpc_security_group_ids = ["${aws_security_group.etcd.id}"]
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

resource "aws_instance" "etcd_3" {
    ami = "${module.util.ami_id}"
    subnet_id = "${var.subnets["data2"]}"
    instance_type = "${module.util.instance_type}"
    iam_instance_profile = "${module.util.iam_instance_profile}"
    private_ip = "${var.private_ip_addr["etcd_3"]}"

    tags {
        Name = "ETCD 3"
        Owner = "${module.util.owner}"
        Environment = "DEV"
        Project = "${module.util.project}"
        Zone = "Data-AZ-2"
    }

    vpc_security_group_ids = ["${aws_security_group.etcd.id}"]
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

resource "aws_lb" "etcd-lb" {
    name            = "lb-etcd-dev"
    internal        = true
    load_balancer_type = "network"
    subnets         = ["${var.subnets["data1"]}","${var.subnets["data2"]}"]
}

resource "aws_lb_listener" "etcd-listener" {
    load_balancer_arn = "${aws_lb.etcd-lb.arn}"
    port              = "2739"
    protocol          = "TCP"

    default_action {
        target_group_arn = "${aws_lb_target_group.etcd-tg.arn}"
        type             = "forward"
    }
}

resource "aws_lb_target_group" "etcd-tg" {
  name     = "tg-etcd-dev"
  port     = 2739
  protocol = "TCP"
  vpc_id   = "vpc-c270a4bb"
  target_type = "ip"

  stickiness = []
}

resource "aws_lb_target_group_attachment" "etcd-1" {
  target_group_arn = "${aws_lb_target_group.etcd-tg.arn}"
  target_id        = "${aws_instance.etcd_1.private_ip}"
  port             = 2739
}

resource "aws_lb_target_group_attachment" "etcd-2" {
  target_group_arn = "${aws_lb_target_group.etcd-tg.arn}"
  target_id        = "${aws_instance.etcd_2.private_ip}"
  port             = 2739
}

resource "aws_lb_target_group_attachment" "etcd-3" {
  target_group_arn = "${aws_lb_target_group.etcd-tg.arn}"
  target_id        = "${aws_instance.etcd_3.private_ip}"
  port             = 2739
}

#### Zuul App Zone

resource "aws_lb" "zuul-app-lb" {
    name            = "lb-zuul-app-dev"
    internal        = true
    load_balancer_type = "application"
    security_groups = ["${aws_security_group.lb-zuul-app.id}"]
    subnets         = ["${var.subnets["app1"]}","${var.subnets["app2"]}"]


}

resource "aws_lb_listener" "zuul-app-listener" {
    load_balancer_arn = "${aws_lb.zuul-app-lb.arn}"
    port              = "8080"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_lb_target_group.zuul-app-tg.arn}"
        type             = "forward"
    }
}

resource "aws_lb_target_group" "zuul-app-tg" {
  name     = "tg-zuul-app-dev"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-c270a4bb"
  target_type = "ip"
}

resource "aws_lb_target_group_attachment" "zuul-app-1" {
  target_group_arn = "${aws_lb_target_group.zuul-app-tg.arn}"
  target_id        = "${aws_instance.zuul_app_1.private_ip}"
  port             = 8080
}

resource "aws_lb_target_group_attachment" "zuul-app-2" {
  target_group_arn = "${aws_lb_target_group.zuul-app-tg.arn}"
  target_id        = "${aws_instance.zuul_app_2.private_ip}"
  port             = 8080
}

#### Zuul Data Zone

resource "aws_lb" "zuul-data-lb" {
    name            = "lb-zuul-data-dev"
    internal        = true
    load_balancer_type = "application"
    security_groups = ["${aws_security_group.lb-zuul-data.id}"]
    subnets         = ["${var.subnets["data1"]}","${var.subnets["data2"]}"]


}

resource "aws_lb_listener" "zuul-data-listener" {
    load_balancer_arn = "${aws_lb.zuul-data-lb.arn}"
    port              = "8080"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_lb_target_group.zuul-data-tg.arn}"
        type             = "forward"
    }
}

resource "aws_lb_target_group" "zuul-data-tg" {
  name     = "tg-zuul-data-dev"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-c270a4bb"
  target_type = "ip"
}

resource "aws_lb_target_group_attachment" "zuul-data-1" {
  target_group_arn = "${aws_lb_target_group.zuul-data-tg.arn}"
  target_id        = "${aws_instance.zuul_data_1.private_ip}"
  port             = 8080
}

resource "aws_lb_target_group_attachment" "zuul-data-2" {
  target_group_arn = "${aws_lb_target_group.zuul-data-tg.arn}"
  target_id        = "${aws_instance.zuul_data_2.private_ip}"
  port             = 8080
}
