oc volumes dc/docker-registry --add --overwrite -t pvc --claim-name=nfs-claim1 --name=resgitry-storage

oc get pv
oc get pvc
