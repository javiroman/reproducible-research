# Cluster-wide & Project-wide default Node Selector
#
# Node selectors are used in conjunction with labeled nodes to control pod
# placement.

# 
# 1. Cluster-wide default Node Selector.
#
# As a cluster administrator, you can set the cluster-wide default node
# selector to restrict pod placement to specific nodes. Edit the master
# configuration file at /etc/origin/master/master-config.yaml and add a value
# for a default node selector. This is applied to the pods created in all
# projects without a specified nodeSelector value:

sudo sed -i 's/defaultNodeSelector: ""/defaultNodeSelector: "region=primary"/' /etc/origin/master/master-config.yaml

sudo systemctl restart atomic-openshift-master

#
# 2. Project-wide default Node Selector for "Default Project"
#
# Namespaces are intended for use in environments with many users spread across
# multiple teams, or projects. Namespaces are a way to divide cluster resources
# between multiple uses. A Kubernetes namespace provides a mechanism to scope
# resources in a cluster. In OpenShift, a project is a Kubernetes namespace
# with additional annotations. Namespaces provide a unique scope for:
#
# - Named resources to avoid basic naming collisions.
# - Delegated management authority to trusted users.
# -The ability to limit community resource consumption.
#
# Most objects in the system are scoped by namespace, but some are excepted and
# have no namespace, including nodes and users.  The "Default Namespace" is for
# objects with no other namespace, so the default namespace is an internal
# namespace used for openshift infrastructure services. You can list the current
# namespaces in a cluster using: oc get namespaces

# DO THIS -> oc edit namespace default
# 
# apiVersion: v1
# kind: Namespace
# metadata:
#  Annotations:
#      openshift.io/node-selector: “region=infra”
#      openshift.io/sa.initialized-roles: "true"

