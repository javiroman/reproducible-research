echo "Creating a metrics-deployer service account ..."
oc create serviceaccount metrics-deployer

# the metrics-deployer service account must also be granted the edit permission
# for the openshift-infra project
echo "Gratting permission for openshirt-infra project for metrics-deployer account ..."
oc adm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer

# The Heapster component requires access to the master server to list all
# available nodes and access the /stats endpoint for each node. Before it can
# do this, the Heapster service account requires the cluster-reader permission:
# The Heapster service account is created automatically during the Deploying the
# Metrics Components step.
echo "Grant Heapster cluster-reader privileges to find all of the nodes and access their /stats endpoints"
oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster

oc secrets new metrics-deployer nothing=/dev/null
