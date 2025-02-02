data "tls_certificate" "eks" {
  url = var.issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = var.issuer
}


//---- AWS Load Balancer Controller
data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume_role_policy.json
  name               = "aws-load-balancer-controller"
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  policy = file("./AWSLoadBalancerController.json")
  name   = "AWSLoadBalancerController"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

//---- Secret Manager
data "aws_iam_policy_document" "aws_secret_manager_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:secret-manager-service-account"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_secret_manager_role" {
  assume_role_policy = data.aws_iam_policy_document.aws_secret_manager_assume_role_policy.json
  name               = "secret-manager-controller"
}

resource "aws_iam_policy" "aws_secret_manager_policy" {
  policy = file("./AwsSecretManagerPolicy.json")
  name   = "SecretManagerPolicy"
}

resource "aws_iam_role_policy_attachment" "aws_secret_manager_attach" {
  role       = aws_iam_role.aws_secret_manager_role.name
  policy_arn = aws_iam_policy.aws_secret_manager_policy.arn
}

//---- Amazon EFS CSI driver
data "aws_iam_policy_document" "efs-csi-controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "efs-csi-controller" {
  assume_role_policy = data.aws_iam_policy_document.efs-csi-controller_assume_role_policy.json
  name               = "efs-csi-controller"
}

resource "aws_iam_policy" "efs-csi-controller" {
  policy = file("./EFS_CSI_Driver_Policy.json")
  name   = "EFS_CSI_Driver"
}


//---- opensearch
resource "aws_iam_policy" "fluent-bit-policy" {
  policy = file("./fluent-bit-policy.json")
  name   = "fluent-bit-policy"
}

resource "aws_iam_role" "fluent-bit-role" {
  assume_role_policy = data.aws_iam_policy_document.fluent-bit_assume_role_policy.json
  name               = "fluent-bit-role"
}


data "aws_iam_policy_document" "fluent-bit_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:logging:fluent-bit"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}