resource "aws_efs_file_system" "efs" {
  creation_token = "efs"
}

resource "aws_efs_mount_target" "mount_target" {
  count          = length(var.private_subnets_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = element(var.private_subnets_ids[*], count.index)
  security_groups = [aws_security_group.allow_nfs_inbound.id]
}

resource "aws_security_group" "allow_nfs_inbound" {
  name        = "allow_nfs_inbound"
  description = "Allow NFS inbound traffic from provided security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "NFS from VPC"
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_range]
  }
}