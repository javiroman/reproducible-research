systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server nfs-lock nfs-idmap

# checking the service
exportfs -s
showmount -e

# NFS client
mountstats

DOMAIN=example.com

for node in oscppoc-master.${DOMAIN} \
            oscppoc-node1.${DOMAIN} \
                    oscppoc-node2.${DOMAIN} ; do

        ssh $node "showmount -e oscppoc-mn.${DOMAIN}"
        ssh $node "mount oscppoc-mn.${DOMAIN}:/var/export/pvs/pv1 /mnt/"
        ssh $node "umount /mnt/"
done

