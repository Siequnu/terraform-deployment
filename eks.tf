module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "eks-cluster"
  cluster_version = "1.24"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_security_group_additional_rules = {

    efs_ingress = {
      description = "EFS ingress"
      protocol    = "-1"
      from_port   = 2049
      to_port     = 2049
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  }

  vpc_id     = aws_vpc.dev.id
  subnet_ids = [aws_subnet.dev-private-1.id, aws_subnet.dev-private-2.id]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 200
    instance_types = ["t3.xlarge"]
  }

  eks_managed_node_groups = {
    nodegroup = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.large"]
    }
  }
}

resource "aws_ecr_repository" "example-repo" {
  name                 = "ecr-name"
  image_tag_mutability = "MUTABLE"
}