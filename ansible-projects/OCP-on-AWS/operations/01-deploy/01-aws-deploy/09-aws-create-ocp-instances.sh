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
MASTER1_SUBNET="subnet-ca1b1aae" # pri-az-1a
MASTER2_SUBNET="subnet-d4a9ada2" # pri-az-1b
MASTER3_SUBNET="subnet-dfdb9987" # pri-az-1c
#  two extra disks used for Docker storage and OpenShift ephemeral volumes. 
NODE_FLAVOR="t2.medium "
INF1_SUBNET="subnet-ca1b1aae"  # pri-az-1a
INF2_SUBNET="subnet-d4a9ada2"  # pri-az-1b
INF3_SUBNET="subnet-dfdb9987"  # pri-az-1c
APP1_SUBNET="subnet-d4a9ada2" # pri-az-1b
APP2_SUBNET="subnet-dfdb9987" # pri-az-1c

GENERAL_KEYPAR="bastion1"

#
# Master 1
#
MASTER1_SG=$(aws ec2 create-security-group \
    --group-name Master1SG \
    --description "Security group Master 1" \
    --vpc-id $AWS_VPC --query GroupId --output text)

MASTER1_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $MASTER1_SG \
    --subnet-id $MASTER1_SUBNET --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $MASTER1_INSTANCE \
    --tags "Key=Name, Value=Master1"

echo "Created Master1 instance: $MASTER1_INSTANCE"

#
# Master 2
#
MASTER2_SG=$(aws ec2 create-security-group \
    --group-name Master2SG \
    --description "Security group Master 2" \
    --vpc-id $AWS_VPC --query GroupId --output text)

MASTER2_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $MASTER2_SG \
    --subnet-id $MASTER2_SUBNET --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $MASTER2_INSTANCE \
    --tags "Key=Name, Value=Master2"

echo "Created Master2 instance: $MASTER2_INSTANCE"

#
# Master 3
#
MASTER3_SG=$(aws ec2 create-security-group \
    --group-name Master3SG \
    --description "Security group Master 3" \
    --vpc-id $AWS_VPC --query GroupId --output text)

MASTER3_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $MASTER3_SG \
    --subnet-id $MASTER3_SUBNET --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $MASTER3_INSTANCE \
    --tags "Key=Name, Value=Master3"

echo "Created Master3 instance: $MASTER3_INSTANCE"

#
# Infra1
#
INF1_SG=$(aws ec2 create-security-group \
    --group-name Infra1SG \
    --description "Security group Infra 1" \
    --vpc-id $AWS_VPC --query GroupId --output text)

INF1_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $INF1_SG \
    --subnet-id $INF1_SUBNET --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $INF1_INSTANCE \
    --tags "Key=Name, Value=Infra1"

echo "Created Infra1 instance: $INF1_INSTANCE"


#
# Infra2
#
INF2_SG=$(aws ec2 create-security-group \
    --group-name Infra2SG \
    --description "Security group Infra 2" \
    --vpc-id $AWS_VPC --query GroupId --output text)

INF2_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $INF2_SG \
    --subnet-id $INF2_SUBNET --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $INF2_INSTANCE \
    --tags "Key=Name, Value=Infra2"

echo "Created Infra2 instance: $INF2_INSTANCE"

#
# Infra3
#
INF3_SG=$(aws ec2 create-security-group \
    --group-name Infra3SG \
    --description "Security group Infra 3" \
    --vpc-id $AWS_VPC --query GroupId --output text)

INF3_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $INF3_SG \
    --subnet-id $INF3_SUBNET --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $INF3_INSTANCE \
    --tags "Key=Name, Value=Infra3"

echo "Created Infra3 instance: $INF3_INSTANCE"


#
# App1
#
APP1_SG=$(aws ec2 create-security-group \
    --group-name App1SG \
    --description "Security group App 1" \
    --vpc-id $AWS_VPC --query GroupId --output text)

APP1_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $APP1_SG \
    --subnet-id $APP1_SUBNET --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $APP1_INSTANCE \
    --tags "Key=Name, Value=App1"

echo "Created App1 instance: $APP1_INSTANCE"

#
# App2
#
APP2_SG=$(aws ec2 create-security-group \
    --group-name App2SG \
    --description "Security group App 2" \
    --vpc-id $AWS_VPC --query GroupId --output text)

APP2_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $MASTER_FLAVOR \
    --key-name $GENERAL_KEYPAR \
    --security-group-ids $APP2_SG \
    --subnet-id $APP2_SUBNET --query Instances[0].InstanceId --output text)

aws ec2 create-tags \
    --resources $APP2_INSTANCE \
    --tags "Key=Name, Value=App2"

echo "Created App2 instance: $APP2_INSTANCE"


