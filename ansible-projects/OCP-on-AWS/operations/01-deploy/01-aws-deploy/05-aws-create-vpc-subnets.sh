# To create VPC subnet blocks.
#
# The Availability Zone for the subnet: AWS selects one for you. If you create
# more than one subnet in your VPC, we may not necessarily select a different
# zone for each subnet. So you have to setup the correct AZ for your
# requeriments.
#
# This example modifies subnets to specify that all instances launched
# into this subnet are assigned a public IPv4 address.

#
# Public subnets blocks with AZ HA.
#
SUBNET_PUB_AZ1A=$(aws ec2 create-subnet --vpc-id $AWS_VPC \
    --cidr-block 10.20.1.0/24 \
    --availability-zone eu-west-1a --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_PUB_AZ1A --tags Key=ocptest-vpc,Value=pub-az-1a
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUB_AZ1A --map-public-ip-on-launch
echo "Created public subnet block: $SUBNET_PUB_AZ1A"

SUBNET_PUB_AZ1B=$(aws ec2 create-subnet --vpc-id $AWS_VPC \
    --cidr-block 10.20.2.0/24 \
    --availability-zone eu-west-1b --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_PUB_AZ1B --tags Key=ocptest-vpc,Value=pub-az-1b
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUB_AZ1B --map-public-ip-on-launch
echo "Created public subnet block: $SUBNET_PUB_AZ1B"

SUBNET_PUB_AZ1C=$(aws ec2 create-subnet --vpc-id $AWS_VPC \
    --cidr-block 10.20.3.0/24 \
    --availability-zone eu-west-1c --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_PUB_AZ1C --tags Key=ocptest-vpc,Value=pub-az-1c
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUB_AZ1C --map-public-ip-on-launch
echo "Created public subnet block: $SUBNET_PUB_AZ1C"

#
# Private subnets blocks with AZ HA.
#
SUBNET_PUB_AZ1A=$(aws ec2 create-subnet --vpc-id $AWS_VPC \
    --cidr-block 10.20.4.0/24 \
    --availability-zone eu-west-1a --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_PUB_AZ1A --tags Key=ocptest-vpc,Value=pri-az-1a
echo "Created private subnet block: $SUBNET_PUB_AZ1A"

SUBNET_PUB_AZ1B=$(aws ec2 create-subnet --vpc-id $AWS_VPC \
    --cidr-block 10.20.5.0/24 \
    --availability-zone eu-west-1b --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_PUB_AZ1B --tags Key=ocptest-vpc,Value=pri-az-1b
echo "Created private subnet block: $SUBNET_PUB_AZ1B"

SUBNET_PUB_AZ1C=$(aws ec2 create-subnet --vpc-id $AWS_VPC \
    --cidr-block 10.20.6.0/24 \
    --availability-zone eu-west-1c --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_PUB_AZ1C --tags Key=ocptest-vpc,Value=pri-az-1c
echo "Created private subnet block: $SUBNET_PUB_AZ1C"



