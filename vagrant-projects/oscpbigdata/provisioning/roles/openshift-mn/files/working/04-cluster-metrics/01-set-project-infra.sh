# The kubelet exposes metrics that can be collected and stored in back-ends by
# Heapster.  As an OpenShift Container Platform administrator, you can view a cluster’s
# metrics from all containers and components in one user interface. These metrics
# are also used by horizontal pod autoscalers in order to determine when and how
# to scale. Heapster retrieves a list of all nodes from the master server, then
# contacts each node individually through the /stats endpoint. From there,
# Heapster scrapes the metrics for CPU, memory and network usage, then exports
# them into Hawkular Metrics.
#
# Note: If resource limits are defined for your project, then you can also see
# a donut chart for each pod. The donut chart displays usage against the
# resource limit. For example: 145 Available of 200 MiB, with the donut chart
# showing 55 MiB Used.

# Verify the metrics service in /etc/origin/master/master-config.yaml for the master node:
# 
# assetConfig:
#  logoutURL: ""
#  masterPublicURL: https://oscppoc-master.example.com:8443
#  publicURL: https://oscppoc-master.example.com:8443/console/
#  metricsPublicURL: "https://metrics.cloudapps.example.com/hawkular/metrics"
#  servingInfo:


#
# Metrics
#
# To enable cluster metrics, you must next configure the following:
#
# [METRICS-1] Service Accounts: You must configure service accounts for
#
#     [METRICS-1-A] Metrics Deployer
#     [METRICS-1-B] Heapster
# 
# [METRICS-2] Metrics Data Storage
#
# [METRICS-3] Metrics Deployer

oc login -u system:admin 

# 1. ------
# You must deploy the components for cluster metrics in the openshift-infra
# project. This allows HPAs to discover the Heapster service and use it to
# retrieve metrics for autoscaling
oc project openshift-infra

# Modify the openshift-infra project’s node selector to use region=infra.
# The default node selector for this project (namespace in kuberntes).
#
# oc edit namespace openshift-infra

# You can do this with this command (instead of edit):
oc annotate namespace openshift-infra openshift.io/node-selector='region=infra' --overwrite


