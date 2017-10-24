for i in $(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$AWS_VPC" | jq '.Subnets[] | .SubnetId' | tr -d '"'); do
    echo "deleting non-default subnet block: $i"
    aws ec2 delete-subnet --subnet-id $i
done
