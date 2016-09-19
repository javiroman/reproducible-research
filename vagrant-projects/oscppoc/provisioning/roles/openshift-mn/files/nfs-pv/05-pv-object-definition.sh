cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0001
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  nfs:
    path: /var/export/pvs/pv1
    server: oscppoc-mn.example.com
  persistentVolumeReclaimPolicy: Recycle
!

oc get pv
oc describe pv
