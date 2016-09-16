ssh-keygen -f /root/.ssh/id_rsa -N ''

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

echo StrictHostKeyChecking no >> /etc/ssh/ssh_config

ssh 127.0.0.1 uname -a

for node in oscppoc-master.ocp.example.com \
	oscppoc-node1.ocp.example.com  \
	oscppoc-node2.ocp.example.com; do
	
	ssh-copy-id root@$node ;
done

echo "chekcking ...."

ssh oscppoc-master.ocp.example.com uname -a
ssh oscppoc-node1.ocp.example.com uname -a
ssh oscppoc-node2.ocp.example.com uname -a



