hosts="ose-master1.redhat.lan \
ose-master2.redhat.lan \
ose-master3.redhat.lan \
ose-node1.redhat.lan \
ose-node2.redhat.lan \
ose-node3.redhat.lan \
ose-mn.redhat.lan \
ose-lb.redhat.lan"

for i in $hosts; do
	echo -ne "$i: "
	ip=$(dig $i +short)
	echo -ne "$ip -> "
	dig -x $ip +short
	echo
done
