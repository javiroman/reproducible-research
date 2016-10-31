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

# Notes:
#
# Two API Objects: PersistenVolume PV and PersistentVolumeClaim PVC.
#
# PVCs are specific to a project and are created and used by developers as a
# means to use a PV. PV resources on their own are not scoped to any single
# project; they can be shared across the entire OpenShift Enterprise cluster
# and claimed from any project. After a PV has been bound to a PVC, however,
# that PV cannot then be bound to additional PVCs. This has the effect of
# scoping a bound PV to a single namespace (that of the binding project).
# So Claims and Pods must be in the same namespace!!
#
# PVCs are defined by a PersistentVolumeClaim API object, which represents a
# request for storage by a developer. It is similar to a pod in that pods
# consume node resources and PVCs consume PV resources. For example, pods can
# request specific levels of resources (e.g., CPU and memory), while PVCs can
# request specific storage capacity and access modes (e.g, they can be mounted
# once read/write or many times read-only).
#
# Claims are matched to volumes with similar access modes. **The only two
# matching criteria are access modes and size**. A claim’s access modes represent
# a request. Therefore, the user may be granted more, but never less. For
# example, if a claim requests RWO, but the only volume available was an NFS PV
# (RWO+ROX+RWX), the claim would match NFS because it supports RWO.
#
# OpenShift Enterprise supports the following PersistentVolume plug-ins:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - NFS
# - HostPath (single node testing only)
# - GlusterFS
# - Ceph RBD
# - OpenStack Cinder
# - AWS Elastic Block Store (EBS)
# - GCE Persistent Disk
# - iSCSI
# - Fibre Channel
# All volumes with the same modes are grouped, then sorted by size (smallest to
# largest). The binder gets the group with matching modes and iterates over
# each (in size order) until one size matches.
#
# The access modes are: (the matching criterira together the size)
# ~~~~~~~~~~~~~~~~~~~~
# Access ModeCLI AbbreviationDescription
# - ReadWriteOnce (RWO): The volume can be mounted as read-write by a single node.
# - ReadOnlyMany (ROX):  The volume can be mounted read-only by many nodes.
# - ReadWriteMany (RWX): The volume can be mounted as read-write by many nodes.
