variable "target_group_port"{ default = 80 }

variable "vpc_id"{}

variable "health_check_path"{ default = "/" }

variable "target_group_name"{ default = "Forgot to name" }

variable "load_balancer_arn"{}

variable "listener_port"{ default = 80 }

variable "instance_ids"{ type = "list" }

variable "app_port"{ default = 80 }
