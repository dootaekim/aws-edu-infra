########## Common Configs ##########
environment     = "prd"
aws_region      = "ap-northeast-2"
# assume_role_arn = "arn:aws:iam::362820019109:role/IAM-ECS-TASK-JENKINS"

########## Terraform State File Configs ########## 
s3_bucket         = "terraform-state-file-489178515218"
s3_folder_project = "aws-edu-infra"
s3_region         = "ap-northeast-2"
s3_tfstate_file   = "aws-infra.tfstate"