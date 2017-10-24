echo "Working in VPC: $AWS_VPC"

# Base Images
RHEL_IMAGE="RHEL-7.3_HVM_GA-20161026-x86_64-1-Access2-GP2"
RHEL_AMI_ID="ami-e3ade590"

#
# OCP Image Flavors
#
#  three extra disks used for Docker storage, OpenShift ephermal volumes, and
#  ETCD
MASTER_FLAVOR="m4.large"
NODE_FLAVOR="t2.medium "
# Pre-created key par.
GENERAL_KEYPAR="bastion2"

#
# Master 
#
MASTER_SG=$(aws ec2 create-security-group \
    --group-name PocMasterSG \
    --description "Security group PocMaster" \
    --vpc-id $AWS_VPC --query GroupId --output text)

aws ec2 authorize-security-group-ingress \
    --group-id $MASTER_SG \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

MASTER_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $MASTER_SG \
    --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $MASTER_INSTANCE \
    --tags "Key=Name, Value=PocMaster"

echo "Created Master instance: $MASTER_INSTANCE"

#
# Infra Node
#
INF_SG=$(aws ec2 create-security-group \
    --group-name PocInfSG \
    --description "Security group PocInf" \
    --vpc-id $AWS_VPC --query GroupId --output text)

INF_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $NODE_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $INF_SG \
    --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $INF_INSTANCE \
    --tags "Key=Name, Value=PocInfra"

echo "Created Infra instance: $INF_INSTANCE"

#
# App Node 1
#
APP1_SG=$(aws ec2 create-security-group \
    --group-name PocApp1SG \
    --description "Security group PocApp1" \
    --vpc-id $AWS_VPC --query GroupId --output text)

APP1_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $NODE_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $APP1_SG \
    --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $APP1_INSTANCE \
    --tags "Key=Name, Value=PocApp1"

echo "Created App1 instance: $APP1_INSTANCE"

#
# App Node 2
#
APP2_SG=$(aws ec2 create-security-group \
    --group-name PocApp2SG \
    --description "Security group PocApp2" \
    --vpc-id $AWS_VPC --query GroupId --output text)

APP2_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $NODE_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $APP2_SG \
    --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $APP2_INSTANCE \
    --tags "Key=Name, Value=PocApp2"

echo "Created App2 instance: $APP2_INSTANCE"

