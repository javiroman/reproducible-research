#
# [METRICS-2] Metrics Data Storage
#
# Running OpenShift Container Platform cluster metrics with persistent storage
# means that your metrics will be stored to a persistent volume and be able to
# survive a pod being restarted or recreated. This is ideal if you require your
# metrics data to be guarded from data loss.
#
# The size of the persisted volume can be specified with the CASSANDRA_PV_SIZE
# template parameter. By default it is set to 10 GB, which may or may not be
# sufficient for the size of the cluster you are using. If you require more
# space, for instance 100 GB, you could specify it with something like this:
#
# $ oc process -f metrics-deployer.yaml -v \
#    HAWKULAR_METRICS_HOSTNAME=hawkular-metrics.example.com,CASSANDRA_PV_SIZE=100Gi \
#    | oc create -f -

#
# in the master or mn remote client
#
cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cassandra-volume
spec:
  capacity:
    storage: 20Gi
  accessModes:
  - ReadWriteOnce
  awsElasticBlockStore:
    fsType: "ext4" 
    volumeID: "vol-026a8a2cc42505d18" 
!

oc get pv

