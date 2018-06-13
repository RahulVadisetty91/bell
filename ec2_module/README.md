# EC2 Module

This module is provided to allow users an easy and standard way of creating ec2 instances in our cloud environment.

## How to use

Here we will go over what you will need to do in order to bring in and correctly utilize this module to produce the ec2 instances you require.

### How to bring in

In order to utilize this module in your terraform scripts, you must pull in this folder as a module in your script:

```terraform
module "ec2_mod"{
    source = "path/to/ec2_module/folder"
}
```

The above code snippet should be included in your script (preferably at the top for organization) with the correct path to this folder in the source variable. This tells terraform to go to that location and get the module from there and run it.

### How to run

Once you have pulled in the module to your script, Terraform will begin trying to run this module along with your scripts on your next run.

This module **requires** two input values in order to run correctly.

1. ec2\_names
2. ec2\_zones

`ec2\_names` is a list of the names you wish to apply to the ec2 instances this module will be creating.
`ec2\_zones` is a map which maps the names provided to the availability zone to create these instances in.

Example values:

```
ec2_names = [ "Test", "Test2" ]
ec2_zones = {
    "Test" = "app1"
    "Test2" = "app1"
}
```

Please note that the values in ec2\_names should match to the keys in ec2\_zones

Once you have your values determined, you will need to feed them into your import of the module like this:

```terraform
module "ec2_mod"{
    source = "path/to/ec2_module/folder"

    ec2_names = [ "Test", "Test2" ]
    ec2_zones = {
        "Test" = "app1"
        "Test2" = "app1"
    }
}
```

This will correctly pass in those values to the module and allow it to run correctly. You could also make variables in your script that contain those values and change the call to something like this:

```terraform
module "ec2_mod"{
    source = "path/to/ec2_module/folder"

    ec2_names = "${var.names}"
    ec2_zones = "${var.zones}"
}
```

### Outputs from module

After you import this module, you will also be able to reference some of its values inside of your own script.

Values currently available:

1. ec2\_ids - An array of the ID's of the ec2 instances created
2. ec2\_ips - An array of the private IP addresses of the ec2 instances created

Here is an example of calling these values (assuming in your import of the module you called it `ec2_mod`):

```
"${module.ec2_mod.ec2_ids}"
"${module.ec2_mod.ec2_ips}"
```
