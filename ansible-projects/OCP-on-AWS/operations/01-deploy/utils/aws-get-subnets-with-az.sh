for i in $(aws ec2 describe-subnets \
    --filters "Name=vpc-id, Values=$AWS_VPC" \
    --query 'Subnets[].[SubnetId,Tags[0].Value]' --output text); do
    echo "non-default subnet block: $i"
done
