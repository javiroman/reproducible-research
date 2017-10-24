oc project default

cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: registry-storage
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  nfs:
    path: /var/export/pvs/registry-storage
    server: ip-10-0-0-141.eu-west-1.compute.internal
  persistentVolumeReclaimPolicy: Recycle
!

oc get pv

