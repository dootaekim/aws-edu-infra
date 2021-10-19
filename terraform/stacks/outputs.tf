output "region" {
  description = "AWS region"
  value = var.aws_region
}
output "vpc_id" {
  description = "VPC ID"
  value = module.vpc.vpc_id
}
# Deployment 등은 kubectl 로 하는것이 좋을것같다
# 참고자료 https://www.youtube.com/watch?v=Qy2A_yJH5-o
# grab our EKS config
# aws eks update-kubeconfig --name getting-started-eks --region ap-northeast-2