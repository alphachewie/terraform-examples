cluster_name                      = "example-cluster"
kubernetes_version                = "v1.12"
cidr_block                        = "10.0.0.0/16"
target_region                     = "eu-north-1"
eks_cluster_node_instance_type    = "t3-large"
node_autoscale_group_size_min     = 1
node_autoscale_group_size_desired = 1
node_autoscale_group_size_max     = 2
