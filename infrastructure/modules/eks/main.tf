data "aws_iam_role" "eks_cluster_role" {
  name = "desafio-devops-eks-cluster-role"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.name
  role_arn = data.aws_iam_role.eks_cluster_role.arn
  version  = "1.27"

  vpc_config {
    security_group_ids = [
      data.aws_security_group.public_sg.id
    ]

    subnet_ids = [
      data.aws_subnet.public_subnet_us_east_1a.id,
      data.aws_subnet.public_subnet_us_east_1b.id
    ]
  }

  tags = {
    "kubernetes.io/cluster/${var.name}"    = "shared"
    "alpha.eksctl.io/cluster-oidc-enabled" = "true"
  }
}

data "aws_security_group" "public_sg" {
  name = "public-security-group"
}

resource "aws_eks_node_group" "cluster" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  version         = var.k8s_version
  node_group_name = "${var.name}-node-group"
  node_role_arn   = data.aws_iam_role.eks_nodes.arn
  subnet_ids = [
    data.aws_subnet.public_subnet_us_east_1a.id,
    data.aws_subnet.public_subnet_us_east_1b.id
  ]

  instance_types = var.nodes_instances_sizes

  scaling_config {
    desired_size = lookup(var.auto_scale_cpu, "scale_up_add", 1)
    max_size     = lookup(var.auto_scale_cpu, "scale_up_threshold", 2)
    min_size     = 0
  }

  tags = {
    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}


data "aws_iam_role" "eks_nodes" {
  name = "desafio-devops-eks-nodes"
}

data "aws_subnet" "private_subnet_us_east_1a" {
  filter {
    name   = "tag:Name"
    values = ["desafio-devops-Private-us-east-1a"]
  }
}

data "aws_subnet" "private_subnet_us_east_1b" {
  filter {
    name   = "tag:Name"
    values = ["desafio-devops-Private-us-east-1b"]
  }
}

data "aws_subnet" "public_subnet_us_east_1a" {
  filter {
    name   = "tag:Name"
    values = ["desafio-devops-Public1"]
  }
}


data "aws_subnet" "public_subnet_us_east_1b" {
  filter {
    name   = "tag:Name"
    values = ["desafio-devops-Public2"]
  }
}

