data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available"{

}



resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
#   version = "2.78.0"
  name               = "aws-edu-vpc"
  cidr               = "10.1.1.0/25"
  azs                = var.vpc_azs
  private_subnets    = ["10.1.1.0/27", "10.1.1.32/27"]
  public_subnets     = ["10.1.1.64/27", "10.1.1.96/27"]
  enable_nat_gateway = true
  # 외부에서 들어오는 요청은 api-gateway에서 받으며, 인터넷향 요청이 서비스에 영향 줄 일은 없어 단일 nat 사용해도 서비스에 영향 없을 것으로 보임
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"  = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"  = "1"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "12.2.0"
  cluster_name =  var.cluster_name
  cluster_version = "1.18"
  subnets = module.vpc.private_subnets
  cluster_create_timeout = "1h"
  cluster_endpoint_private_access = true
  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name = "worker-group-1"
      instance_type = "t2.small"
      additional_userdata = "echo foo bar"
      asg_desired_capaciry = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles = var.map_roles
  # map_users = var.map_users
  map_accounts = var.map_accounts
}