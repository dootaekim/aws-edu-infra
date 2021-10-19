#!/bin/bash

# Get directory we are running from
DIR=$(pwd)
COMMONFILE="$DIR/$1"
STAGEFILE="$DIR/$2"

if [ ! -f "$COMMONFILE" ]; then
   echo "Configuration file not found: $COMMONFILE"
   return 1
fi

if [ ! -f "$STAGEFILE" ]; then
   echo "Configuration file not found: $STAGEFILE"
   return 1
fi

ENVIRONMENT=$(grep environment "$COMMONFILE" | awk -F '=' '{print $2}' | sed -e 's/["\ ]//g')
AWSDEPLOYREGION=$(grep aws_region "$COMMONFILE" | awk -F '=' '{print $2}' | sed -e 's/["\ ]//g')
S3BUCKET=$(grep s3_bucket "$COMMONFILE" | awk -F '=' '{print $2}' | sed -e 's/["\ ]//g')
S3FOLDERPROJECT=$(grep s3_folder_project "$COMMONFILE" | awk -F '=' '{print $2}' | sed -e 's/["\ ]//g')
S3REGION=$(grep s3_region "$COMMONFILE" | awk -F '=' '{print $2}' | sed -e 's/["\ ]//g')
S3TFSTATEFILE=$(grep s3_tfstate_file "$COMMONFILE" | awk -F '=' '{print $2}' | sed -e 's/["\ ]//g')

if [ -z "$ENVIRONMENT" ]
then
    echo "set-env: 'environment' variable not set in configuration file."
    return 1
fi
if [ -z "$S3BUCKET" ]
then
    echo "set-env: 's3_bucket' variable not set in configuration file."
    return 1
fi
if [ -z "$S3FOLDERPROJECT" ]
then
    echo "set-env: 's3_folder_project' variable not set in configuration file."
    return 1
fi
if [ -z "$S3REGION" ]
then
    echo "set-env: 's3_region' variable not set in configuration file."
    return 1
fi
if [ -z "$AWSDEPLOYREGION" ]
then
    echo "set-env: 'aws_region' variable not set in configuration file."
    return 1
fi
if [ -z "$S3TFSTATEFILE" ]
then
    echo "set-env: 's3_tfstate_file' variable not set in configuration file."
    echo "e.g. s3_tfstate_file=\"infrastructure.tfstate\""
    return 1
fi


cat << EOF > "$DIR/backend.tf"
terraform {
  backend "s3" {
    bucket = "${S3BUCKET}"
    key    = "${S3FOLDERPROJECT}/${AWSDEPLOYREGION}/${ENVIRONMENT}/${S3TFSTATEFILE}"
    region = "${S3REGION}"
  }
}
EOF

export TF_WARN_OUTPUT_ERRORS=1
rm -rf "$DIR/.terraform"
cd "$DIR"

echo "set-env: Initializing terraform"
terraform init > /dev/null