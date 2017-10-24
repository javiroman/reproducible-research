#
# Deploying the EFK Stack
#

export KIBANA_URL=kibana.apps.microserviceslab.com
export MASTER_URL=https://ip-172-31-46-214.eu-west-1.compute.internal:8443

#
# Specifying Deployer Parameters
#
# Parameters for the EFK DEPLOYMENT may be specified in the form of a:
#  - ConfigMap, 
#  - a secret, 
#  - or template parameters (which are passed to the deployer
#    in environment variables). 
#
# The deployer looks for each value first in a logging-deployer ConfigMap, 
# then a logging-deployer secret, then as an  environment variable. 
# Any or all may be omitted if not needed.

# Using a ConfigMap:
# 
# Typicall parameters: you should at least specify the host name at
# which Kibana should be exposed to client browsers, and also the master URL
# where client browsers will be directed to for authenticating to OpenShift
# Container Platform.

oc create configmap logging-deployer \
--from-literal kibana-hostname=$KIBANA_URL \
--from-literal public-master-url=$MASTER_URL \
--from-literal es-cluster-size=1 \
--from-literal es-instance-ram=2G \
--from-literal es-nodeselector="region=infra" \
--from-literal kibana-nodeselector="region=infra" \
--from-literal curator-nodeselector="region=infra"


# kibana-hostname -> The external host name for web clients to reach Kibana.
# public-master-url -> The external URL for the master; used for OAuth purposes.
# es-cluster-size (default: 1)-> The number of instances of Elasticsearch to
#                               deploy. Redundancy requires at least three, 
#                               and more can be used for scaling.
# es-instance-ram (default: 8G) -> Amount of RAM to reserve per Elasticsearch
#             instance. The default is 8G (for 8GB), and it must be at least 512M. 
#             Possible suffixes are G,g,M,m.
#

# To edit this ConfigMap YAML file after creating it: 
#       oc edit configmap logging-deployer

# Create a secret to provide security-related files to the deployer. 
# The contents of the secret are optional, and will be randomly generated if 
# not supplied.
oc create secret generic logging-deployer

#
# Deploying the EFK Stack
#
# The EFK stack is deployed using a template to create a deployer pod that
# reads the deployment parameters and manages the deployment. This deployment
# will use the previous ConfigMap.
oc new-app logging-deployer-template

# To inspect the progress:
# oc get pod -w
# oc get pod/<pod_name> -w
# oc describe pod/<pod_name>
# oc logs -f <pod_name>

# oc get pod
# NAME                          READY     STATUS      RESTARTS   AGE
# logging-curator-1-50yfb       1/1       Running     0          4m
# logging-es-e3kc6rle-1-41eji   1/1       Running     0          4m
# logging-kibana-1-ea2ev        2/2       Running     0          4m


# Once deployment completes successfully, you may need to label the nodes for
# Fluentd to deploy on, and may have other adjustments to make to the deployed
# components. These tasks are described in the next section.

# For ElasticSearch deployment
# oc get dc `oc get dc | grep logging-es | awk '{print $1}'` -o json | sed '/containers/i "nodeSelector": { "region": "infra" },' | oc replace -f -

# For Kibana deployment
# oc get dc `oc get dc | grep kibana | awk '{print $1}'` -o json | sed '/containers/i "nodeSelector": { "region": "infra" },' | oc replace -f -

# Manually inspection with:
# oc edit dc logging-es-xd1ys7qo
# oc edit dc logging-kibana


# To view all current Elasticsearch deployments:
# oc get dc --selector logging-infra=elasticsearch





