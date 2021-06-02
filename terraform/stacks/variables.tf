########## Common Configs ##########
variable "environment" {
  type = string
}
variable "aws_region" {
  type = string
  default = "ap-southeast-2"
}

########## Terraform State File Configs ########## 
variable "s3_bucket" {
  type = string
}
variable "s3_region" {
  type = string
}
variable "s3_folder_project" {
  type = string
}
variable "s3_tfstate_file" {
  type = string
}
# variable "config_bucket_prefix" {
#   default = "config"
# }
# variable "config_bucket_key_prefix" {
#   default = "config"
# }
########## VPC configuration ##########
variable "vpc_azs" {
  type = list
}

########## EKS configuration ##########
variable "cluster_name" {
  default = "getting-started-eks"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap"
  type = list(string)

  default = [
    "489178515218"
  ]
}
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap"
  type = list(object({
    rolearn = string
    username = string
    groups = list(string)
  }))

  default = [
    {
      rolearn = "arn:aws:iam::489178515218:role/role1"
      username = "role1"
      groups = ["system:masters"]
    },
    {
      rolearn = "arn:aws:iam::489178515218:role/role2"
      username = "role2"
      groups = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}
