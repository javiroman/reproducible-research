aws ec2 describe-subnets --filters "Name=vpc-id, Values=$AWS_VPC"

aws ec2 describe-subnets --filters "Name=vpc-id, Values=$AWS_VPC" | jq '.Subnets[] | .CidrBlock'

aws ec2 describe-subnets --filters "Name=vpc-id, Values=$AWS_VPC" \
    --query Subnets[*].CidrBlock \
    --output text
