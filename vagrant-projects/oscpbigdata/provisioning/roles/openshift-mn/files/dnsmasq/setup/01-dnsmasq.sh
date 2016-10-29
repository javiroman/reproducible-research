for node in oscppoc-master.example.com \
	oscppoc-node1.example.com  \
	oscppoc-node2.example.com; do
	
	scp files/hosts root@$node:/etc/hosts
	scp files/resolv.conf root@$node:/etc/resolv.conf
done

echo "setup dnsmasq"
