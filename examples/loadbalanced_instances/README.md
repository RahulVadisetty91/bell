# Loadbalanced Instances

This is an example script to show how to create a terraform script that will create a list of EC2 instances, place the EC2 instances within a target group and associate that target group with the passed in load balancer.

### Inputs

This script will need a few inputs in order to run successfully.

1. the backend key value - sets the name of the state file in order to let terraform keep track of and maintain the infrastructure

    If you have copied this script into your own application, then you can hardcode your key into the state.tf file inside the backend block. If you have not copied this script and are running it from HQR-Terraform, then you must provide the key in the `init` command line call `terraform init -backend-config="key=nameOfYourApp.state"`

2. names - an array of names to associate with the ec2 instances created. The number of names equals the number of instances that will be created.

     If you have copied this script into your own application, then you can hardcode your names into the terraform.tfvars file. If you have not copied this script and are running it from HQR-Terraform, then you must provide the names in the `plan` or `apply` command line call `terraform apply -var names=["Name1", "Name2", "Name3"]`

3. zones - a map that should have the keys match the names provided and the values be the availability zone you want each of these instances to be created in.

    If you have copied this script into your own application, then you can hardcode your zones into the terraform.tfvars file. If you have not copied this script and are running it from HQR-Terraform, then you must provide the names in the `plan` or `apply` command line call `terraform apply -var 'zones={"Name1" = "app1", "Name2" = "app2", "Name3" = "app3"}'`

4. vpc_id - The vpc to create the load balancer in. This defaults to the Sandbox vpc. If you want this to be created in other environments, then you will need to provide a new value to this

5. target\_group\_name - The name to attach to the target group. This can be anything you want, but try to make it meaningful to ensure you can easily find the target group when you need to.

6. lb_arn - The arn of the load balancer you want to attach the target group to.