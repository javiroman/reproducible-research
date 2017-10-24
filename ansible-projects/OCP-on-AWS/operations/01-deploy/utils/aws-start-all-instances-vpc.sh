echo "starting all instances from VPC: $AWS_VPC"
instances_list=$(aws ec2 describe-instances \
    --filters Name=vpc-id,Values=$AWS_VPC \
    --query 'Reservations[].Instances[].InstanceId' \
    --output text)

for i in $instances_list; do
    echo -ne "starting instance: "
    aws ec2 start-instances \
        --instance-ids $i \
        --query StartingInstances[].InstanceId \
        --output text
done
