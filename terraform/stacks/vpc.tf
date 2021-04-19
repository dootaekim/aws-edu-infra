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
}