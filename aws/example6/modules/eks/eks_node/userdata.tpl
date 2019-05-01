#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${eks_endpoint}' --b64-cluster-ca '${eks_certificate_authority}' '${eks_cluster_name}'
/opt/aws/bin/cfn-signal --exit-code $? \
         --stack ${stack_info} \
         --resource NodeGroup  \
         --region ${aws_region_current_name}