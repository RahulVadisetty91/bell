variable "names"{type = "list"}

variable "zones"{type = "map"}

# This is set to default to the sandbox vpc for ease of use. This will need
# to be over-written in order to perform higher up deployments.
variable "vpc_id"{
    type = "string"
    default = "vpc-ce75a1b7"
    }

variable "target_group_name"{type = "string"}

variable "lb_arn"{type = "string"}