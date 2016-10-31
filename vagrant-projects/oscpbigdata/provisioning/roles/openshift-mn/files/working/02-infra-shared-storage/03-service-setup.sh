source ../01-infra-setup/00-hostnames

hosts="${HOST_MASTER} \
${HOST_NODE1} \
${HOST_NODE2} \
${HOST_NODE3}"

systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server nfs-lock nfs-idmap

# checking the service
exportfs -s
showmount -e

# NFS client
mountstats

for node in $hosts; do
	echo "Executing in -> $node"
    ssh $node "showmount -e ${HOST_MN}"
	echo "Testing client mount ..."
    ssh $node "mount ${HOST_MN}:/var/exports/pvs/pv1 /mnt/"
    ssh $node "umount /mnt/"
done
