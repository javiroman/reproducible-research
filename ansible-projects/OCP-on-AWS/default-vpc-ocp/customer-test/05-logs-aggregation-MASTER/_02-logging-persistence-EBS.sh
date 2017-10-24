# Persistent Elasticsearch Storage

# By default, the deployer creates an ephemeral deployment in which all of a
# pod’s data is lost upon restart. For production usage, specify a persistent
# storage volume for each Elasticsearch deployment configuration. You can create
# the necessary persistent volume claims before deploying or have them created
# for you. The PVCs must be named based on the es-pvc-prefix setting, which
# defaults to logging-es-; each PVC name will have a sequence number added to
# it, so logging-es-1, logging-es-2, and so on. If a PVC needed for the
# deployment exists already, it is used; if not, and es-pvc-size has been
# specified, it is created with a request for that size.

# in the master or mn remote client create the PV
cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: elasticsearch-volume
spec:
  capacity:
    storage: 20Gi
  accessModes:
  - ReadWriteOnce
  awsElasticBlockStore:
    fsType: "ext4" 
    volumeID: "vol-0b7dec373f1e14f50" 
!

# in the master or mn remote client create the PVC for use in the project.
cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: logging-es-1
spec:
  accessModes:
    - ReadWriteOnce 
  resources:
    requests:
      storage: 20Gi
!
