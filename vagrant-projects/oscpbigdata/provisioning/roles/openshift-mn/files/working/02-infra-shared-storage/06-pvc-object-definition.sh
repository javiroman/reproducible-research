# The next step can be to create a persistent volume claim (PVC) which will 
# bind to the new PV.
#
# The accessModes do not enforce security, but rather act as labels to match 
# a PV to a PVC.This claim will look for PVs offering 1Gi or greater capacity. 
# The name of the claim is “nfs-claim1

for i in $(seq 10); do
cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-claim${i}
spec:
  accessModes:
    - ReadWriteOnce 
  resources:
    requests:
      storage: 1Gi
!
done

oc get pvc
oc describe pvc
