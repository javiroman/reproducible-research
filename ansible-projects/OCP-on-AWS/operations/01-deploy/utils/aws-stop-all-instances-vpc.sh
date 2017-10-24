echo "stopping all instances from VPC: $AWS_VPC"
instances_list=$(aws ec2 describe-instances \
    --filters Name=vpc-id,Values=$AWS_VPC \
    --query 'Reservations[].Instances[].InstanceId' \
    --output text)

for i in $instances_list; do
    echo -ne "stopping instance: "
    aws ec2 stop-instances \
        --instance-ids $i \
        --query StoppingInstances[].InstanceId \
        --output text
done
