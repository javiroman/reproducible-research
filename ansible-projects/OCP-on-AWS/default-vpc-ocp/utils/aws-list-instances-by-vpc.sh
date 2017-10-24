aws ec2 describe-instances \
    --filters Name=vpc-id,Values=$AWS_VPC \
    --query 'Reservations[].Instances[].[PrivateIpAddress,InstanceId,Tags[?Key==`Name`].Value[]]' \
    --output text | sed 's/None$/None\n/' | sed '$!N;s/\n/ /'
