# Loadbalanced Instances

This is an example script to show how to create a terraform script that will create a list of load balancers.

### Inputs

This script will need a few inputs in order to run successfully.

1. the backend key value - sets the name of the state file in order to let terraform keep track of and maintain the infrastructure

    If you have copied this script into your own application, then you can hardcode your key into the state.tf file inside the backend block. If you have not copied this script and are running it from HQR-Terraform, then you must provide the key in the `init` command line call `terraform init -backend-config="key=nameOfYourApp.state"`

2. lb_names - an array of names to associate with the load balancers created. The number of names equals the number of load balancers that will be created.

     If you have copied this script into your own application, then you can hardcode your names into the terraform.tfvars file. If you have not copied this script and are running it from HQR-Terraform, then you must provide the names in the `plan` or `apply` command line call `terraform apply -var lb_names=["Name1", "Name2", "Name3"]`

3. lb_zones - a map that should have the keys match the names provided and the values be the availability zone you want each of these load balancers to be created in.

    If you have copied this script into your own application, then you can hardcode your zones into the terraform.tfvars file. If you have not copied this script and are running it from HQR-Terraform, then you must provide the names in the `plan` or `apply` command line call `terraform apply -var 'lb_zones={"Name1" = "app1", "Name2" = "app2", "Name3" = "app3"}'`
