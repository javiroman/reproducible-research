# - Creates a VPC with the specified IPv4 CIDR block. The smallest VPC you can
# create uses a /28 netmask (16 IPv4 addresses), and the largest uses a /16
# netmask (65,536 IPv4 addresses). 
#
# - By default, each instance you launch in the VPC has the default DHCP options,
# which includes only a default DNS server that we provide (AmazonProvidedDNS).
#
# - DHCP options sets are associated with your AWS account so that you can use
# them across all of your virtual private clouds (VPC).
#
# - The Amazon EC2 instances you launch into a nondefault VPC are private by
# default; they're not assigned a public IPv4 address unless you specifically
# assign one during launch, or you modify the subnet's public IPv4 address
# attribute. By default, all instances in a nondefault VPC receive an
# unresolvable host name that AWS assigns (for example, ip-10-0-0-202). You can
# assign your own domain name to your instances, and use up to four of your own
# DNS servers. To do that, you must specify a special set of DHCP options to
# use with the VPC.
#
# - You can specify the instance tenancy value for the VPC when you create it.
# You can't change this value for the VPC after you create it. Dedicated 
# instances are Amazon EC2 instances that run in a virtual private
# cloud (VPC) on hardware that's dedicated to a single customer. Your Dedicated
# instances are physically isolated at the host hardware level from instances
# that belong to other AWS accounts. Dedicated instances may share hardware
# with other instances from the same AWS account that are not Dedicated
# instances.

# creates a VPC with the specified IPv4 CIDR block.

echo "Creating VPC with ID: "
aws ec2 create-vpc --cidr-block 10.20.0.0/16 --query 'Vpc.VpcId' --output text
