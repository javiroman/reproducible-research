# in the NFS server (mn)
mkdir /var/export/pvs/cassandra/
echo "/var/export/pvs/cassandra 192.168.121.0/24(rw,sync,no_root_squash)" >> /etc/exports
chown -R nfsnobody:nfsnobody /var/export/pvs/cassandra/
chmod 777 -R /var/export/pvs/cassandra/
systemctl restart rpcbind nfs-server nfs-lock nfs-idmap

# in the master or mn remote client
cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cassandra-volume
spec:
  capacity:
    storage: 2Gi
  accessModes:
  - ReadWriteOnce
  - ReadWriteMany
  nfs:
    path: /var/export/pvs/cassandra
    server: oscppoc-mn.example.com
  persistentVolumeReclaimPolicy: Recycle
!

oc get pv

