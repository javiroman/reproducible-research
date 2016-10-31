# Group IDs and NFS
#
# The recommended way to handle NFS access (assuming it is not an option to
# change permissions on the NFS export) is to use supplemental groups.
# Supplemental groups in OpenShift Enterprise are used for shared storage, of
# which NFS is an example. In contrast, block storage, such as Ceph RBD or iSCSI,
# use the fsGroup SCC strategy and the fsGroup value in the pod’s
# securityContext.
#
# It is generally preferable to use supplemental group IDs to gain access to
# persistent storage versus using user IDs. Supplemental groups are covered
# further in the full Volume Security topic:
# https://docs.openshift.com/enterprise/3.2/install_config/persistent_storage/pod_security_context.html#supplemental-groups



