# AWS Load Balancer Module

This Terraform module provides a template for provisioning AWS Load Balancers.

## How to use

Here we will go over what you will need to do in order to bring in and correctly utilize this module to deploy new Load Balancers.

### How to bring in

In order to utilize this module in your terraform scripts, you must pull in this folder as a module in your script:

```terraform
module "lb_mod" {
    source = "path/to/lb_module/folder"
}
```

The above code snippet should be included in your script (preferably at the top for organization) with the correct path to this folder in the source variable. This tells terraform to go to that location and get the module from there and run it.

### How to run

Once you have pulled in the module to your script, Terraform will begin trying to run this module along with your scripts on your next run.

This module **requires** one input value in order to run correctly.

1. lb_names

`lb_names` is the name you wish to apply to the load balancer instance being created.

Example values:

```
lb_names = ["LB1"]
```

2. lb_zones

`lb_zones` is the map of names from the lb_names to the zones that those load balancers must be created in. (Example, app or data).

Example values:

```
lb_zones = {
    "LB1" = "data"
}
```

Once you have your values determined, you will need to feed them into your import of the module like this:

```terraform
module "lb_mod" {
    source = "path/to/lb_module/folder"

    lb_names = ["LB1"]
    lb_zones = {
        "LB1" = "data"
    }
}
```

This will correctly pass in those values to the module and allow it to run correctly. You could also make variables in your script that contain those values and change the call to something like this:

```terraform
module "lb_mod" {
    source = "path/to/lb_module/folder"

    lb_names = "${var.lb_names}"
    lb_zones = "${var.lb_zones}
}
```

### Outputs from module

After you import this module, you will also be able to reference some of its values inside of your own script.

Values currently available:

N/A