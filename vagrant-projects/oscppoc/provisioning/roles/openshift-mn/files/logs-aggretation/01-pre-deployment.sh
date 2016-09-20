# The logging subsystem consists of multiple components commonly abbreviated as
# the "ELK" stack (though modified here to be the "EFK" stack).
#
# - ElasticSearch:
# ElasticSearch is a Lucene-based indexing object store into which all logs are
# fed. It should be deployed with redundancy, can be scaled up using more
# replicas, and should use persistent storage.
# 
# - Fluentd:
# Fluentd is responsible for gathering log entries from nodes, enriching them
# with metadata, and feeding them into ElasticSearch.
# 
# -Kibana:
# Kibana presents a web UI for browsing and visualizing logs in ElasticSearch.
# 
# - Logging auth proxy:
# In order to authenticate the Kibana user against OpenShift's Oauth2, a proxy is
# required that runs in front of Kibana.
# 
# - Deployer:
# The deployer enables the user to generate all of the necessary
# key/certs/secrets and deploy all of the components in concert.
# 
# - Curator
# Curator allows the admin to remove old indices from Elasticsearch on a
# per-project basis.

# Choose the project you want to hold your logging infrastructure. It can be
# any project.

oc login -u system:admin
# Add this node selector annotation to the new project to cause its pods to
# be deployed only on nodes that have the label region=primary.
oc adm new-project logging --node-selector region=primary
# oc adm new-project logging --node-selector=""
oc project logging

# Configure the logging-deployer to generate its own SSL certificates
# The logging deployer can accept the input of various SSL certificates, but if
# a value of nothing=/dev/null is used, it generates its own certificates.
# https://docs.openshift.com/enterprise/latest/install_config/aggregate_logging.html#pre-deployment-configuration
oc secrets new logging-deployer nothing=/dev/null

# Create a service account "loggin-deployer"
oc create serviceaccount logging-deployer

# Enable the logging-deployer service account to edit the project contents.
# By default service accounts are not allowed to edit project contents.
# Here we are enabling the logging-deployer service account to create the objects
# needed for a logging deployment
oc policy add-role-to-user edit system:serviceaccount:logging:logging-deployer

# Enable the Fluentd service account, which the deployer will create, that
# requires special privileges to operate Fluentd. Add the fluentd service 
# account to the privileged security context:
oc adm policy add-scc-to-user privileged system:serviceaccount:logging:aggregated-logging-fluentd 

# Give the Fluentd service account permission to read labels and other metadata from all pods.
oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:logging:aggregated-logging-fluentd
























