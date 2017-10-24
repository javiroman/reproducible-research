aws ec2 describe-instances --filters Name=vpc-id,Values=$AWS_VPC --query 'Reservations[].Instances[].[PublicIpAddress,InstanceId]'

# ssh -i $HOME/.ssh/bastion1.pem ec2-user@34.249.245.33
