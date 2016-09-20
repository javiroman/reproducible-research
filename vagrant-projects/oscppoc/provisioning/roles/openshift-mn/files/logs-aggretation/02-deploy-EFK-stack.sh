# Deploying the EFK Stack

KIBANA_URL=kibana.cloudapps.example.com
MASTER_URL=https://oscppoc-master.example.com:8443

# Create the logging-deployer. Running the deployer creates a deployer pod 
# and prints its name.

oc process logging-deployer-template -n openshift \
  -v KIBANA_HOSTNAME=${KIBANA_URL} \
  -v ES_CLUSTER_SIZE=1 \
  -v ES_INSTANCE_RAM=1024M \
  -v PUBLIC_MASTER_URL=${MASTER_URL} \
  -v ENABLE_OPS_CLUSTER=false \
  -v IMAGE_VERSION=v3.2,IMAGE_PREFIX=registry.access.redhat.com/openshift3/ \
  | oc create -f -

# OUTPUT FROM THE COMMAND [begin]
# The deployer has created secrets, service accounts, templates, and
# component deployments required for logging. You now have a few steps to
# run as cluster-admin. Consult the deployer docs for more detail.
# 
# If you are replacing a previous deployment, delete the previous objects:
#     oc delete route,is,oauthclient --selector logging-infra=support
# 
# Create the supporting definitions:
#     oc process logging-support-template | oc create -f -
# 
# ElasticSearch:
# --------------
# Clustered instances have been created as individual deployments.
# 
#     oc get dc --selector logging-infra=elasticsearch
# 
# Your deployments will likely need to specify persistent storage volumes
# and node selectors. It's best to do this before spinning up fluentd.
# To attach persistent storage, you can modify each deployment through
# 'oc volume'.
# 
# Fluentd:
# --------------
# Fluentd is deployed with no replicas. Scale it to the number of nodes:
# 
#     oc scale dc/logging-fluentd --replicas=3
#     oc scale rc/logging-fluentd-1 --replicas=3
# 
# Kibana:
# --------------
# You may scale the Kibana deployment for redundancy:
# 
#     oc scale dc/logging-kibana --replicas=2
#     oc scale rc/logging-kibana-1 --replicas=2
# OUTPUT FROM THE COMMAND [end]


# Execute the oc get pods -w command repeatedly until you see that the pods 
# are running. To view the logs of the pod:
# oc logs logging-deployer-x6vbs


# Add Node Selectors for Elasticsearch and Kibana

# The templates do not have a provision to configure any node selectors for 
# Elasticsearch or Kibana (we are using a template). As such, they could 
# end up anywhere in the cluster within the primary region. To fix this, 
# you edit all of the DeploymentConfig objects, and add a node selector for 
# ONLY the Elasticsearch and Kibana objects.

# For ElasticSearch deployment
oc get dc `oc get dc | grep logging-es | awk '{print $1}'` -o json | sed '/containers/i "nodeSelector": { "region": "infra" },' | oc replace -f -

# For Kibana deployment
oc get dc `oc get dc | grep kibana | awk '{print $1}'` -o json | sed '/containers/i "nodeSelector": { "region": "infra" },' | oc replace -f -

# Manually inspection with:
# oc edit dc logging-es-xd1ys7qo
# oc edit dc logging-kibana




