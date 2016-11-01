oc project default

cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: registry-storage-claim
spec:
  accessModes:
    - ReadWriteOnce 
  resources:
    requests:
      storage: 10Gi
!

oc get pvc

