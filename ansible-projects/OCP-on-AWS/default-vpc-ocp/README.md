Default VPC
~~~~~~~~~~~
A default VPC is ready for you to use — you can immediately start launching
instances into your default VPC without having to perform any additional
configuration steps. A default VPC combines the benefits of the advanced
networking features provided by the EC2-VPC platform with the ease of use of
the EC2-Classic platform.

When we create a default VPC, we do the following to set it up for you:

- Create a VPC with a size /16 IPv4 CIDR block.
- Create a default subnet in each Availability Zone.
- Create an Internet gateway and connect it to your default VPC.
- Create a main route table for your default VPC with a rule that sends all IPv4
  traffic destined for the Internet to the Internet gateway.
- Create a default security group and associate it with your default VPC.
- Create a default network access control list (ACL) and associate it with your
  default VPC.
- Associate the default DHCP options set for your AWS account with your default
  VPC.

Instances that you launch into a default subnet receive both a public IPv4
address and a private IPv4 address. Instances in a default subnet also receive
both public and private DNS hostnames. Instances that you launch into a
nondefault subnet in a default VPC don't receive a public IPv4 address or a DNS
hostname. 

Default Subnets
~~~~~~~~~~~~~~~
The CIDR block for a default VPC is always a /16 netmask (172.31.0.0/16). This
provides up to 65,536 private IPv4 addresses. The netmask for a default subnet
is always /20, which provides up to 4,096 addresses per subnet, a few of which
are reserved for our use.

By default, a default subnet is a public subnet, because the main route table
sends the subnet's traffic that is destined for the Internet to the Internet
gateway. You can make a default subnet a private subnet by removing the route
from the destination 0.0.0.0/0 to the Internet gateway. However, if you do
this, any EC2 instance running in that subnet can't access the Internet.

Launching an EC2 Instance into Your Default VPC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you launch an EC2 instance without specifying a subnet, it's automatically
launched into a default subnet in your default VPC. By default, we select an
Availability Zone for you and launch the instance into the corresponding subnet
for that Availability Zone. Alternatively, you can select the Availability Zone
for your instance by selecting its corresponding default subnet in the console,
or by specifying the subnet or the Availability Zone in the CLI.



