//----ALB Controller
resource "helm_release" "aws-load-balancer-controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.1"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "image.tag"
    value = "v2.4.5"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.aws_load_balancer_controller_arn
  }
}

//----ServiceAccounts


//----AWS EFS CSI driver
resource "helm_release" "efs-csi-driver" {
  name = "efs-csi-driver"

  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  version    = "2.3.7"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com"
  }
  set {
    name  = "serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.efs_csi_controller_arn
  }
}

//---- Secrets Store CSI Driver and ASCP
resource "helm_release" "secrets_store_csi_driver_chart" {
  name       = "csi-secrets-store"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"

  set {
    name  = "serviceAccount.name"
    value = "secret-manager-sa"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.aws_secret_manager_role_arn
  }
}

resource "helm_release" "ascp" {
  name       = "secrets-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

}

resource "helm_release" "testtask" {
  name = "testtask"

  repository = "./charts"
  chart      = "testtask"

  set {
    name  = "csi.volumeHandle"
    value = var.file_system_id
  }

  depends_on = [
    helm_release.aws-load-balancer-controller,
    helm_release.efs-csi-driver
  ]
}
