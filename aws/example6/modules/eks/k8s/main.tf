data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${var.eks_cluster_name}"
}

provider "kubernetes" {
  host                   = "${var.eks_cluster_endpoint}"
  cluster_ca_certificate = "${base64decode(var.eks_ca_cert_data)}"
  load_config_file       = false
  token                  = "${data.aws_eks_cluster_auth.cluster_auth.token}"
}

resource "kubernetes_config_map" "eks-node-config-map" {
  "metadata" {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data {
    mapRoles = <<ROLES
  - rolearn: ${var.eks_node_role_id}
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
ROLES
  }
}
