//----Secret Service Manager Account
resource "kubernetes_manifest" "secret_manager_service_account" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "annotations" = {
        "eks.amazonaws.com/role-arn" = "${var.aws_secret_manager_role_arn}"
      }
      "name"      = "secret-manager-service-account"
      "namespace" = "default"
    }
  }
}

//----AWS Load Balancer Controler Service Account
resource "kubernetes_manifest" "serviceaccount_aws_load_balancer_controller" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "annotations" = {
        "eks.amazonaws.com/role-arn" = "${var.aws_load_balancer_controller_role_arn}"
      }
      "name"      = "aws-load-balancer-controller"
      "namespace" = "kube-system"
    }
  }
}

//----ConfigMap
resource "kubernetes_manifest" "configmap" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "CONTENTFUL_DELIVERY_API_HOST" = "${var.CONTENTFUL_DELIVERY_API_HOST}"
      "CONTENTFUL_PREVIEW_API_HOST"  = "${var.CONTENTFUL_PREVIEW_API_HOST}"
      "NODE_ENV"                     = "${var.NODE_ENV}"
      "PORT"                         = "${var.PORT}"
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "name" = "configmap"
    }
  }
}

//----SecretProviderClass
resource "kubernetes_manifest" "secretproviderclass_secrets_provider" {
  manifest = {
    "apiVersion" = "secrets-store.csi.x-k8s.io/v1"
    "kind"       = "SecretProviderClass"
    "metadata" = {
      "name" = "secrets-provider"
    }
    "spec" = {
      "parameters" = {
        "objects" = <<-EOT
        - objectName: ${var.secret_manager_arn}
          jmesPath:
              - path: "CONTENTFUL_SPACE_ID"
                objectAlias: "CONTENTFUL_SPACE_ID"
              - path: "CONTENTFUL_DELIVERY_TOKEN"
                objectAlias: "CONTENTFUL_DELIVERY_TOKEN"
              - path: "CONTENTFUL_PREVIEW_TOKEN"
                objectAlias: "CONTENTFUL_PREVIEW_TOKEN"                        
        EOT
        "region"  = "${var.region}"
      }
      "provider" = "aws"
      "secretObjects" = [
        {
          "data" = [
            {
              "key"        = "CONTENTFUL_SPACE_ID"
              "objectName" = "CONTENTFUL_SPACE_ID"
            },
            {
              "key"        = "CONTENTFUL_DELIVERY_TOKEN"
              "objectName" = "CONTENTFUL_DELIVERY_TOKEN"
            },
            {
              "key"        = "CONTENTFUL_PREVIEW_TOKEN"
              "objectName" = "CONTENTFUL_PREVIEW_TOKEN"
            },
          ]
          "secretName" = "Contenful"
          "type"       = "Opaque"
        },
      ]
    }
  }
}

#----Service
resource "kubernetes_manifest" "service_testtask" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name" = "testtask"
    }
    "spec" = {
      "ports" = [
        {
          "port"       = var.PORT
          "protocol"   = "TCP"
          "targetPort" = var.targetPort
        },
      ]
      "selector" = {
        "app" = "testtask"
      }
      "type" = "NodePort"
    }
  }
}

//----Deployment
resource "kubernetes_manifest" "deployment_deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "name" = "deployment"
    }
    "spec" = {
      "replicas" = 2
      "selector" = {
        "matchLabels" = {
          "app" = "testtask"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "testtask"
          }
        }
        "spec" = {
          "containers" = [
            {
              "command" = ["npm", "run", "start:dev"]
              "env" = [
                {
                  "name" = "NODE_ENV"
                  "valueFrom" = {
                    "configMapKeyRef" = {
                      "key"  = "NODE_ENV"
                      "name" = "configmap"
                    }
                  }
                },
                {
                  "name" = "CONTENTFUL_DELIVERY_API_HOST"
                  "valueFrom" = {
                    "configMapKeyRef" = {
                      "key"  = "CONTENTFUL_DELIVERY_API_HOST"
                      "name" = "configmap"
                    }
                  }
                },
                {
                  "name" = "CONTENTFUL_PREVIEW_API_HOST"
                  "valueFrom" = {
                    "configMapKeyRef" = {
                      "key"  = "CONTENTFUL_PREVIEW_API_HOST"
                      "name" = "configmap"
                    }
                  }
                },
                {
                  "name" = "PORT"
                  "valueFrom" = {
                    "configMapKeyRef" = {
                      "key"  = "PORT"
                      "name" = "configmap"
                    }
                  }
                },
                {
                  "name" = "CONTENTFUL_SPACE_ID"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "CONTENTFUL_SPACE_ID"
                      "name" = "secret"
                    }
                  }
                },
                {
                  "name" = "CONTENTFUL_DELIVERY_TOKEN"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "CONTENTFUL_DELIVERY_TOKEN"
                      "name" = "secret"
                    }
                  }
                },
                {
                  "name" = "CONTENTFUL_PREVIEW_TOKEN"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "CONTENTFUL_PREVIEW_TOKEN"
                      "name" = "secret"
                    }
                  }
                },
              ]
              "image" = "${var.image}"
              "name"  = "testtask"
              "ports" = [
                {
                  "containerPort" = var.containerPort
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/mnt/secrets-store"
                  "name"      = "secrets-store-inline"
                  "readOnly"  = true
                },
              ]
            },
          ]
          "serviceAccountName" = "secret-manager-service-account"
          "volumes" = [
            {
              "csi" = {
                "driver"   = "secrets-store.csi.k8s.io"
                "readOnly" = true
                "volumeAttributes" = {
                  "secretProviderClass" = "secrets-provider"
                }
              }
              "name" = "secrets-store-inline"
            },
          ]
        }
      }
    }
  }
}

//----Ingress
resource "kubernetes_manifest" "ingress_testtask" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata" = {
      "annotations" = {
        "alb.ingress.kubernetes.io/certificate-arn" = "${var.certificate-arn}"
        "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
        "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
        "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      }
      "name" = "testtask-ingress"
    }
    "spec" = {
      "ingressClassName" = "alb"
      "rules" = [
        {
          "host" = "${var.host}"
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = "testtask"
                    "port" = {
                      "number" = 3000
                    }
                  }
                }
                "path"     = "/"
                "pathType" = "Prefix"
              },
            ]
          }
        },
      ]
    }
  }
}





