ssh-keygen -f /root/.ssh/id_rsa -N ''

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

echo StrictHostKeyChecking no >> /etc/ssh/ssh_config

ssh 127.0.0.1 uname -a

for node in ose-master.redhat.lan \
	ose-node1.redhat.lan \
	ose-node2.redhat.lan \
	ose-node3.redhat.lan; do
	
	ssh-copy-id root@$node ;
done


