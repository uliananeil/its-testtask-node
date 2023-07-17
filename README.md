This repository contains Terraform modules for AWS Elastic Kubernetes Service and deployed the Nodejs application to the EKS.

**Terraform Modules:**
-
**VPC** 
- creates VPC, Private and Public subnets, Internat Gateway, Route table.

**IAM** creates:
- *IAM OIDC provider* to use AWS Identity and Access Management (IAM) roles for service accounts
- *aws_load_balancer_controller* role
- *aws_secret_manager_role*
- *efs-csi-controller* role
- *fluent-bit-role*

**eks** 
- creates Kubernetes cluster

**eks-nodes** 
- creates nodes in private subnets

A Kubernetes node is a machine that runs containerized applications.

**efs** 
- creates Amazon Elastic File System

Amazon Elastic File System (Amazon EFS) provides serverless, fully elastic file storage so that you can share file data without provisioning or managing storage capacity and performance.

**opensearch** 
- creates Amazon OpenSearch Service
 
Amazon OpenSearch Service is a managed service that makes it easy to deploy, operate, and scale OpenSearch clusters in the AWS Cloud.

**helm**

This module contains Helm charts to get nodejs app to work with AWS services(EFS, Secret Manager, Elastic Load Balancer, OpenSearch):
- *aws-load-balancer-controller*
- *aws-efs-csi-driver*
- *secrets-store-csi-driver*
- *secrets-store-csi-driver-provider-aws*
- *fluent-bit*
- *testtask* 

**Infrastructure:**

![picture of infrastructure](https://github.com/uliananeil/its-testtask-node/blob/master/test-devops-1.JPG)

**To create infrastructure**
-

Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.
Configuration to Terraform modules contains in `infrastructure/aws/<MODULE_NAME>/terragrunt.hcl`

To use it, you:

1. Install Terraform.

2. Install Terragrunt.


To deploy infrastructure:

1. Initialize a working directory containing Terragrunt configuration files

```
terragrunt init
```
2. Create an infrastructure
   
```
terragrunt apply
```

**To destroy:**

```
terragrunt destroy
```
