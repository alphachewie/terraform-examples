## Example 6 : Setting up an AWS EKS Cluster

### Description

In this example we will setup an entire kubernetes cluster and deploy both the Kubernetes dashboard and Tiller to it to
enable Helm to deploy the applications.

The example will utilize the features presented in the previous examples (1-5) to give you a somewhat versatile cluster
setup.

### Modules

#### EKS

##### EKS Cluster [eks_cluster]

This is the root component for a EKS setup. This is basically the Kubernetes master configuration.

##### EKS IAM Roles [eks_iam_roles]

The authorization roles needed for the resources to access each other and outside.

##### EKS Node [eks_node]

The EKS worker nodes configuration including autoscaling group configuration.

##### EKS Security Groups [eks_sec_group]

The security groups for the resources in the cluster enabling access between them and the outside.

##### Kubernetes [k8s]

This is a ConfigMap needed for the worker nodes to be able to register with the cluster.


#### Network

##### Routes [route]

Routing policys for the cluster

##### Subnets [subnet]

The networking configuration

##### Virtual Private Cloud [vpc]

This can be removed if you already have a VPC in your environment and you just want to add a EKS cluster to it.

### Usage

The default values in this example can be found in the `terraform.tfvars` file. Change them, override them or keep them,
do whatever floats your goat.

