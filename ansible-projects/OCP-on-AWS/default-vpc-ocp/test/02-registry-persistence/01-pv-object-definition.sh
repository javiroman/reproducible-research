# 
# During advanced installation, the openshift_registry_selector 
# and openshift_hosted_router_selector Ansible settings are set 
# to "region=infra" by default. The default router and registry 
# will be automatically deployed if a node exists that matches 
# the "region=infra" label.
#
# We have in this deployment the first node infra  as region=infra
# selector, so we can inspect the default Registry and default
# router with this command:
#
# $ oc adm manage-node infra-node.redhat.lan --list-pods
#
# Listing matched pods on node: oscpbigdata-node1.redhat.lan
#
# NAME                      READY     STATUS    RESTARTS   AGE
# docker-registry-1-di62p   1/1       Running   0          1d
# router-1-0n8gl            1/1       Running   0          1d

# Other alternative is:
# oc adm manage-node --selector=”region=infra” --list-pods


oc project default

cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: registry-storage
spec:
  capacity:
    storage: 20Gi
  accessModes:
    - ReadWriteOnce
  awsElasticBlockStore:
    fsType: "xfs" 
    volumeID: "vol-084e2c3a831508d85" 
!

# NOTE: AWS does not support the 'Recycle' recycling policy.
#       persistentVolumeReclaimPolicy: Recycle

oc get pv
oc describe pv

