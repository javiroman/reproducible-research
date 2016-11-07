#
# Note: This step is not mandatory, only for
#       special DHCP configurations.
#
source ./00-hostnames

sudo tee /etc/dhcp/dhclient.conf <<!
# The custom DNS server IP
prepend domain-name-servers ${IP_MN};
!

sudo systemctl restart NetworkManager


