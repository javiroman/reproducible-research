# Elasticsearch
# A highly-available environment requires at least three replicas of
# Elasticsearch; each on a different host. Elasticsearch replicas require their
# own storage, but an OpenShift Enterprise deployment configuration shares
# storage volumes between all its pods. So, when scaled up, the EFK deployer
# ensures each replica of Elasticsearch has its own deployment configuration.

# View all of the current deployments used by Elasticsearch:
oc get dc --selector logging-infra=elasticsearch


# Elasticsearch Storage
# ~~~~~~~~~~~~~~~~~~~~~
# The deployer does not connect any persistent storage to the Elasticsearch
# pods, so any stored data is lost upon restart (the deployer creates an
# ephemeral deploymen). In a realistic scenario, some # kind of external 
# and persistent storage is required. The following example
# specifies a persistent storage volume for the Elasticsearch deployment.

# NOTE: The best-performing volumes are local disks, if it is possible to use
# them. Take a look here for instructions about this:
# https://docs.openshift.com/enterprise/3.2/install_config/aggregate_logging.html

#####################
# Local Host Mounts #
#####################
# [TODO]

##########################
# Network Storage Mounts #
##########################
# If using host mounts is impractical or undesirable, it may be necessary to
# attach block storage as a PersistentVolumeClaim based on a PV as in the 
# following example:

# in the master or mn remote client create the PV
cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: elasticsearch-volume
spec:
  capacity:
    storage: 2Gi
  accessModes:
  - ReadWriteOnce
  nfs:
    path: /var/export/pvs/elasticsearch-storage
    server: oscppoc-mn.example.com
  persistentVolumeReclaimPolicy: Recycle
!

# in the master or mn remote client create the PVC for use in the project.
cat <<! | oc create -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: elasticsearch-claim
spec:
  accessModes:
    - ReadWriteOnce 
  resources:
    requests:
      storage: 2Gi
!

# Look at the pods in the logging project:
oc get dc

oc volume dc/logging-es-r5ip4fal --add --overwrite --name=elasticsearch-storage --type=persistentVolumeClaim --claim-name=elasticsearch-claim

# Fluentd Scale-Out
# ~~~~~~~~~~~~~~~~
# Fluentd starts with zero instances, and it is up to the administrator to scale 
# out Fluentd to create one Fluentd instance for each node.
oc scale dc/logging-fluentd --replicas=3

# Kibana console
# ~~~~~~~~~~~~~~
# To access the Kibana console from the OpenShift Enterprise web console, add 
# the loggingPublicURL parameter in the /etc/origin/master/master-config.yaml 
# file, with the URL of the Kibana console setup in the deployment of ELK.
# KIBANA_URL=kibana.cloudapps.example.com

# As noted many times, you normally do not edit the master configuration file 
# directly, but instead edit the installer options and rerun the installation. 
# This ensures that, in a multi-master environment, you do not lose sync of 
# changes, and also that you do not overwrite changes that were not captured 
# in the installer configuration.

# ...
# assetConfig:
#   logoutURL: ""
#   masterPublicURL: https://oscppoc-master.example.com:8443
#   publicURL: https://oscppoc-master.example.com:8443/console/
#   metricsPublicURL: "https://metrics.cloudapps.example.com/hawkular/metrics"
#   loggingPublicURL: "https://kibana.cloudapps.example.com"
#   servingInfo:
# ...

# Setting the loggingPublicURL parameter creates a View Archive button on the 
# OpenShift Enterprise web console under the Browse → Pods → <pod_name> → Logs tab. 
# This links to the Kibana console. It's importante take into account this
# publics URLs must be those resolved by the wildcard DNS record.

systemctl restart atomic-openshift-master.service


