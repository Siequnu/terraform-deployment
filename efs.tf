#module "efs_csi_driver" {
#  source = "git::https://github.com/DNXLabs/terraform-aws-eks-efs-csi-driver.git"

#  cluster_name                     = module.eks.cluster_id
#  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
#  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
#}

resource "aws_efs_file_system" "efs-file-system" {
  creation_token = var.EFS_FS_CREATION_TOKEN

  tags = {
    Name = "efs-file-system"
  }
}


resource "aws_efs_mount_target" "efs-fs-mount-target-private-1" {
  file_system_id = aws_efs_file_system.efs-file-system.id
  subnet_id      = aws_subnet.dev-private-1.id
  security_groups = [aws_security_group.ssh-allowed.id, aws_security_group.flat.id]
}

resource "aws_efs_mount_target" "efs-fs-mount-target-private-2" {
  file_system_id = aws_efs_file_system.efs-file-system.id
  subnet_id      = aws_subnet.dev-private-2.id
  security_groups = [aws_security_group.ssh-allowed.id, aws_security_group.flat.id]
}