module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.release_name}-eks"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
    }
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    main = {
      min_size     = 1
      max_size     = 3
      desired_size = 1
    }
    elasticsearch = {
      min_size     = 3
      max_size     = 3
      desired_size = 3
      labels = {
        "k8s.whalebone.io/dedicated" = "elasticsearch"
      }
      taints = {
        dedicated = {
          key    = "k8s.whalebone.io/dedicated"
          value  = "elasticsearch"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = local.default_tags
}

data "aws_iam_policy_document" "eks_ebs_csi_driver_assume_role" {
  statement {
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  name               = "${var.release_name}-eks-ebs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.eks_ebs_csi_driver_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
