#
# Aggregating Container Logs
#
# As an OpenShift Container Platform cluster administrator, you can deploy the
# EFK stack to aggregate logs for a range of OpenShift Container Platform
# services. Application developers can view the logs of the projects for which
# they have view access. The EFK stack aggregates logs from hosts and
# applications, whether coming from multiple containers or even deleted pods.
#
# The EFK stack is a modified version of the ELK stack and is comprised of:
#
# - Elasticsearch: An object store where all logs are stored.
# - Fluentd: Gathers logs from nodes and feeds them to Elasticsearch.
# - Kibana: A web UI for Elasticsearch.
#
# Once deployed in a cluster, the stack aggregates logs from ALL NODES and
# PROJECTS into Elasticsearch, and provides a Kibana UI to view any logs.
# Cluster administrators can view all logs, but application developers can only
# view logs for projects they have permission to view.

#
# Pre-deployment Configuration
#
oc login -u system:admin

# The project already exists in OSCP 3.3
oc project logging

# About the Node Selector of LOGGING PROJECT:
#
# The project logging has an node-selector to "" by default. This is important
# and recommended, as Fluentd should be deployed throughout the cluster and any
# selector would restrict where it is deployed. To control component placement,
# specify node selectors per component to be applied to their deployment
# configurations.

# The template for the deployment:
#
# Ansible-based installs should create the logging-deployer-template template
# in the openshift project. We will use this template. Otherwise you can create
# it with the following command:
#
# oc apply -n openshift -f \
#    /usr/share/openshift/examples/infrastructure-templates/enterprise/logging-deployer.yaml

# Create the logging service accounts and custom roles:
oc new-app logging-deployer-account-template

# Enable the deployer service account to create an OAuthClient (normally a
# cluster administrator privilege) for Kibana to use later when authenticating
# against the master:
oc adm policy add-cluster-role-to-user oauth-editor system:serviceaccount:logging:logging-deployer

# Enable the Fluentd service account to mount and read system logs by adding it
# to the privileged security context, and also enable it to read pod metadata
# by giving it the cluster-reader role:

# 1. Enable the Fluentd service account, which the deployer will create, that
# requires special privileges to operate Fluentd. Add the fluentd service 
# account to the privileged security context:
oc adm policy add-scc-to-user privileged system:serviceaccount:logging:aggregated-logging-fluentd 

# 2. Give the Fluentd service account permission to read labels and other metadata from all pods.
oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:logging:aggregated-logging-fluentd



