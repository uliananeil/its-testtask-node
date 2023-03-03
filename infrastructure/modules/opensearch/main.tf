resource "aws_opensearch_domain" "testtask" {
  domain_name    = var.domain_name


  cluster_config {
    instance_type = var.instance_type
    instance_count = var.instance_count
  }

  advanced_security_options {
    enabled                        = var.security_options
    anonymous_auth_enabled         = var.anonymous_auth_enabled
    internal_user_database_enabled = var.internal_user_database_enabled
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  encrypt_at_rest {
    enabled = var.encrypt_at_rest
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.volume_size
  }

 access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "es:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
POLICIES

}
