source ./00-hostnames

hosts="${HOST_MASTER1} \
${HOST_MASTER2} \
${HOST_MASTER3} \
${HOST_REGISTRY1} \
${HOST_REGISTRY2} \
${HOST_REGISTRY3} \
${HOST_LB} \
${HOST_MN} \
${HOST_NODE1} \
${HOST_NODE2} \
${HOST_NODE3} \
${HOST_NODE4} \
${HOST_NODE5}"

ssh-keygen -f /root/.ssh/id_rsa -N ''

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

echo StrictHostKeyChecking no >> /etc/ssh/ssh_config

ssh 127.0.0.1 uname -a

for node in $hosts; do
        ssh-copy-id root@$node
done

echo "chekcking ...."

for node in $hosts; do
	ssh root@$node uname -a
done
