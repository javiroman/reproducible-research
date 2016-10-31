# The volume is owned by nfsnobody and access by all remote users is "squashed"
# (through the all_squash command) for access by nfsnobody. Essentially, this
# scenario disables user permissions for clients who mount the volume: One
# problem you may encounter is that the container cannot modify the permissions
# of the actual volume directory when mounted. In the case of MySQL below,
# MySQL desires that the volume belong to the mysql user and assumes that it
# is, which causes errors later. 

source ../01-infra-setup/00-hostnames

hosts="${HOST_MASTER} \
${HOST_NODE1} \
${HOST_NODE2} \
${HOST_NODE3}"

# mn node
yum -y install nfs-utils

for node in $hosts; do
	echo "Executing in -> $node"
    ssh $node "yum -y install nfs-utils"
done
