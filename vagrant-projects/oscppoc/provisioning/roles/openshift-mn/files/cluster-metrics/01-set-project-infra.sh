oc login -u system:admin 

# You must deploy the components for cluster metrics in the openshift-infra
# project. This allows HPAs to discover the Heapster service and use it to
# retrieve metrics for autoscaling
oc project openshift-infra


# Modify the openshift-infra project’s node selector to use region=infra.
# The default node selector for this project (namespace in kuberntes).
oc edit namespace openshift-infra

# You can do this with this command (instead of edit):

oc annotate namespace openshift-infra openshift.io/node-selector='region=infra' --overwrite


