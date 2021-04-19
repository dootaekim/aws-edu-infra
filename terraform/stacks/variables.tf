########## Common Configs ##########
variable "environment" {
  type = string
}
variable "aws_region" {
  type = string
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