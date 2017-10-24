# Create custom tag for the VPC
aws ec2 create-tags --resources $AWS_VPC --tags Key=vpc,Value=ocptest

# Describe the VPC created
aws ec2 describe-vpcs --vpc-ids $AWS_VPC
