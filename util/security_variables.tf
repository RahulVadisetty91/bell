variable "sg"{
  type = "map"
  default = {
    "app" = ["sg-e8c6fb96"]
    "data" = ["sg-e8c6fb96"]
    "web" = ["sg-08c0fd76"]
    "mgt" = ["sg-e8c6fb96","sg-08c0fd76"]
  }
}

output "security_groups"{
  value = "${var.sg}"
}

variable "zones"{
  type = "map"
  default ={
    "app1" = "app"
    "app2" = "app"
    "app3" = "app"
    "app4" = "app"
    "data1" = "data"
    "data2" = "data"
    "data3" = "data"
    "data4" = "data"
    "mgt1" = "mgt"
    "mgt2" = "mgt"
    "mgt3" = "mgt"
    "mgt4" = "mgt"
    "web1" = "web"
    "web2" = "web"
    "web3" = "web"
    "web4" = "web"
  }
}

output "zone_collection"{
  value = "${var.zones}"
}