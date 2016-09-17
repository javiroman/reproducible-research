echo "... checking named.conf"
sudo named-checkconf

echo "... checking zone ocp.example.com"
sudo named-checkzone ocp.example.com /etc/named/zones/db.ocp.example.com

echo "... checking reverse zone ocp.example.com"
sudo named-checkzone 168.192.in-addr.arpa /etc/named/zones/db.192.168

