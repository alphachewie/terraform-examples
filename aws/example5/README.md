## Example 5 : Aurora database cluster

In this example we will create three single-instance Aurora cluster compatible with Postgresql and MySQL.

I have created two different modules to make it easy to reuse them which is something I really recommend.

The Aurora database consists of a cluster resource and an instance resource, the cluster can contain a number of instances
which is configurable by changing the `count` variable on the instance.

This example also contains empty definitions of parameter groups for both instance and cluster, these could also be extracted
to their own modules or created in the parent resource file instead since the only reference used is the name. The parameters
are divided on both cluster and instance and the easiest way to find which parameter goes where is probably by using the
web console and check the default parameter groups.

And as with the other examples, this is just an example to show you how an Aurora database can be setup.

Grab it, modify it and tweak it to fit your needs!
