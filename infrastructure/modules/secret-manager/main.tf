resource "helm_release" "secrets_store_csi_driver_chart" {
  name       = "csi-secrets-store"
  namespace = "kube-system"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"

    set {
    name  = "serviceAccount.name"
    value = "secret-manager-service-account"
  }
}

resource "helm_release" "ascp" {
  name       = "secrets-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace = "kube-system"

}