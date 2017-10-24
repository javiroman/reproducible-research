echo -ne "File configuration Region: "
aws configure get region --profile default
echo "Default Region: $AWS_DEFAULT_REGION"
