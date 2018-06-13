# AWS Load Balancer Target Group Module

This Terraform module provides a template for provisioning Target Group resources on AWS Load Balancer instances.

## How to use

Here we will go over what you will need to do in order to bring in and correctly utilize this module to produce the Target Groups you require.

### How to bring in

In order to utilize this module in your terraform scripts, you must pull in this folder as a module in your script:

```terraform
module "lb_target_mod" {
    source = "path/to/lb_target_module/folder"
}
```

The above code snippet should be included in your script (preferably at the top for organization) with the correct path to this folder in the source variable. This tells terraform to go to that location and get the module from there and run it.

### How to run

Once you have pulled in the module to your script, Terraform will begin trying to run this module along with your scripts on your next run.

This module **requires** three input values in order to run correctly.

1. vpc_id
2. load_balancer_arn
3. instance_ids

This module also supports the following inputs which have default values if none are defined.

4. target_group_port
5. health_check_path
6. target_group_name
7. listener_port
8. app_port

`vpc_id` is the identifier of the VPC in which to create the target group.
`load_balancer_arn` is the ARN of the load balancer to attach the target group.
`instance_ids` is a list of the instance IDs of the targets to attach.

`target_group_port` will default to "80" if no value is defined.
`health_check_path` will default to "/" if no value is defined.
`target_group_name` will default to "Forgot to name" if no value is defined.
`listener_port` will default to "80" if no value is defined.
`app_port` will default to "80" if no value is defined.

Example values:

```
vpc_id = "vpc-ce75a1b7"
load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:354979567826:loadbalancer/app/Hqr-lb/d151b25a0a397886"
instance_ids = [ "i-069c319583598948b", "i-018e58d82175b2b23", "i-0b5e625cee170b3f7" ] 
target_group_name = "Test_Target_Group"
```

Once you have your values determined, you will need to feed them into your import of the module like this:

```terraform
module "lb_target_mod" {
    source = "path/to/lb_target_module/folder"

    vpc_id = "vpc-ce75a1b7"
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:354979567826:loadbalancer/app/Hqr-lb/d151b25a0a397886"
    instance_ids = [ "i-069c319583598948b", "i-018e58d82175b2b23", "i-0b5e625cee170b3f7" ] 
    target_group_name = "Test_Target_Group"
}
```

This will correctly pass in those values to the module and allow it to run correctly. You could also make variables in your script that contain those values and change the call to something like this:

```terraform
module "lb_mod" {
    source = "path/to/lb_module/folder"

    vpc_id = "${var.vpc_id}"
    load_balancer_arn = "${var.load_balancer_arn}"
    instance_ids = "${var.instance_ids}"
    target_group_name = "${var.target_group_name}"
}
```

### Outputs from module

After you import this module, you will also be able to reference some of its values inside of your own script.

Values available: 

N/A