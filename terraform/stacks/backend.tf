terraform {
  backend "s3" {
    bucket = "terraform-state-file-489178515218"
    key    = "aws-edu-infra/ap-northeast-2/prd/aws-infra.tfstate"
    region = "ap-northeast-2"
  }
}
