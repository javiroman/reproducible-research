#
# Steps for porperly setup of Bastion host (DMZ)
#
# Instances launched inside a VPC can by default only talk to other instances
# in the same VPC and are therefore invisible to the rest of the internet.
# This means they will not accept SSH connections coming from your computer or
# respond to any http requests. 
# 
# 1. Setting up your VPC
# 2. Adding an Internet Gateway: Next we need to connect our VPC to the rest of
#    the internet by attaching an internet gateway. Our VPC would be isolated from
#    the internet without this. An Internet gateway serves two purposes: to
#    provide a target in your VPC route tables for Internet-routable traffic,
#    and to perform network address translation (NAT) for instances that have
#    been assigned public IPv4 addresses.
#    To enable access to or from the Internet for instances in a VPC subnet, you
#    must do the following:
#    - Attach an Internet gateway to your VPC.
#    - Ensure that your subnet's route table points to the Internet gateway.
#    - Ensure that instances in your subnet have a globally unique IP address (public
#      IPv4 address, Elastic IP address, or IPv6 address).
#    - Ensure that your network access control and security group rules allow the
#      relevant traffic to flow to and from your instance.
# 3. Creating a Subnet
# 4. Configuring the Route Table
# 5. Adding a Security Group
# 6. Launching your Instance

echo "Working in VPC: $AWS_VPC"

# Base Images
RHEL_IMAGE="RHEL-7.3_HVM_GA-20161026-x86_64-1-Access2-GP2"
RHEL_AMI_ID="ami-e3ade590"

#
# Bastion host 
#
BASTION_FLAVOR="t2.micro"
BASTION_SUBNET="subnet-fa1b1a9e" # "Value": "pub-az-1a", "Key": "ocptest-vpc"
BASTION_KEYPAR="bastion1"

#
# 1. The key pairs was already created
#
# aws ec2 create-key-pair --key-name my-key --query 'KeyMaterial' --output text # > ~/.ssh/my-key.pem
# chmod 400 ~/.ssh/my-key.pem

#
# 2. Next we need to connect our VPC to the rest of the internet by attaching an
# internet gateway. Our VPC would be isolated from the internet without this.
# http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Internet_Gateway.html
#
internetGatewayId=$(aws ec2 create-internet-gateway \
    --query 'InternetGateway.InternetGatewayId' --output text) 

aws ec2 attach-internet-gateway \
    --internet-gateway-id $internetGatewayId \
    --vpc-id $AWS_VPC

#
# 3. Each subnet needs to have a route table associated with it to specify the
# routing of its outbound traffic. By default every subnet inherits the default
# VPC route table which allows for intra-VPC communication only.

# The following adds a route table to our subnet that allows traffic not meant
# for an instance inside the VPC to be routed to the internet through our earlier
# created internet gateway.
#

routeTableId=$(aws ec2 create-route-table \
    --vpc-id $AWS_VPC \
    --query 'RouteTable.RouteTableId' --output text)

# Asociate route table with subnet
aws ec2 associate-route-table \
    --route-table-id $routeTableId \
    --subnet-id $BASTION_SUBNET

aws ec2 create-route \
    --route-table-id $routeTableId \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $internetGatewayId

#
# 4. Create a security group in your VPC, and add a rule that allows SSH access
# from anywhere.
#
BASTION_SG=$(aws ec2 create-security-group \
    --group-name SSHAccess \
    --description "Security group for SSH access to Bastion Host" \
    --vpc-id $AWS_VPC --query GroupId --output text)

echo "Create Security Group for Bastion: $BASTION_SG"

# If you use 0.0.0.0/0, you enable all IPv4 addresses to access your instance
# using SSH. This is acceptable for this short exercise, but in production,
# authorize only a specific IP address or range of addresses.
aws ec2 authorize-security-group-ingress \
    --group-id $BASTION_SG \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

echo "Created SG Authorization for TCP/22 access"

#
# 5. Launching instance
#
echo "Creating RHEL 7.3 bastion image"
BASTION_INSTANCE=$(aws ec2 run-instances --image-id $RHEL_AMI_ID \
    --count 1 \
    --instance-type $BASTION_FLAVOR \
    --key-name $BASTION_KEYPAR \
    --security-group-ids $BASTION_SG \
    --subnet-id $BASTION_SUBNET --query Instances[0].InstanceId --output text)

echo "Created Bastion instance: $BASTION_INSTANCE"

aws ec2 create-tags \
    --resources $BASTION_INSTANCE \
    --tags "Key=Name, Value=Bastion"

echo "Setup Name for Bastion host: Bastion"

# instanceUrl=`aws ec2 describe-instances --instance-ids $instanceId --query 'Reservations[0].Instances[0].PublicDnsName' --output text`
# ssh -i ~/.ssh/my-key.pem ubuntu@$instanceUrl

