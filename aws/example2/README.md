## Example 2 : Variables and output

Another simple example using variables for some of the settings when creating a Virtual Private Cloud.

Variables can be used on multiple levels in Terraform. In this example we will use it to be able to create different environments
with different settings which is useful for testing purposes. This way you can keep settings that will be the same for all
environments static and only change names and as in this example, subnet.

### Defaults

Variables can have a `description`, `type` and a `default`. The default value can be useful for settings that you _might_ want to change
but you don't have to. If a variable don't have a default you will be prompted for a value when you run the scripts unless
overridden.

You can still override the default values using either a .tfvars file or use the -var parameter to Terraform.

A good description is recommended since that will be presented when prompted.

## terraform.tfvars

A better solution to defaults in the variables are using the `terraform.tfvars` file. This file will always be parsed and
interpreted and can be used for any default values.


### Outputs

When running the apply command you will get the plan for what will be changed, but only the defined settings in the modules/resources
that you are using. Using outputs can be useful to write some other information, like in this case the id of the created vpc.

Outputs can be declared in the main.tf or in a separate file named `output.tf`.

See example 5 for a perfect example for using outputs.


