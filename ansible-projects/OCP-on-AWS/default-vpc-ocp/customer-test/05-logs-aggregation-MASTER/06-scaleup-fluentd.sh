# Fluentd

# Fluentd is deployed as a DaemonSet that deploys replicas according to a node
# label selector (which you can specify with the deployer parameter
# fluentd-nodeselector; the default is logging-infra-fluentd).
# 
# Once you have ElasticSearch running as desired, label the nodes intended for
# Fluentd deployment to feed their logs into ES. The example below would label a
# node named node.example.com using the default Fluentd node selector:
# 
# $ oc label node/node.example.com logging-infra-fluentd=true
#
# Alternatively, you can label all nodes with:
# 

oc label node --all logging-infra-fluentd=true

#
# Labeling nodes requires cluster administrator capability.


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
#   masterPublicURL: https://oscpbigdata-master.redhat.lan:8443
#   publicURL: https://oscpbigdata-master.redhat.lan:8443/console/
#   metricsPublicURL: "https://metrics.cloudapps.redhat.lan/hawkular/metrics"
#   loggingPublicURL: "https://kibana.cloudapps.redhat.lan"
#   servingInfo:
# ...

# Setting the loggingPublicURL parameter creates a View Archive button on the 
# OpenShift Enterprise web console under the Browse → Pods → <pod_name> → Logs tab. 
# This links to the Kibana console. It's importante take into account this
# publics URLs must be those resolved by the wildcard DNS record.

#systemctl restart atomic-openshift-master.service


