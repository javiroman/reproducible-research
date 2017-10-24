#
# Metrics Deployer
#
# The Metrics Deployer deploys and configures all of the metrics components.
# You can configure it by passing in information from secrets and by passing
# parameters to the Metrics Deployer’s template.
#
# Secrets: The Metrics Deployer will auto-generate self-signed certificates for
# use between its components and will generate a re-encrypting route to expose
# the Hawkular Metrics service. This route is what allows the web console to
# access the Hawkular Metrics service.
#
# In order for the browser running the web console to trust the connection
# through this route, it must trust the route’s certificate. This can be
# accomplished by providing your own certificates signed by a trusted Certificate
# Authority. The Metric Deployer’s secret allows you to pass your own
# certificates which it will then use when creating the route.
#
# If you do not wish to provide your own certificates, the router’s default
# certificate will be used instead. A secret named metrics-deployer will still
# be required in this situation. This can be considered a "dummy" secret since
# the secret it specifies is not actually used by the component.
# To create a "dummy" secret that does not specify a certificate value:

oc secrets new metrics-deployer nothing=/dev/null

#
# Modifying the Deployer Template
#

# We can see this template here:
# /usr/share/openshift/examples/infrastructure-templates/enterprise/metrics-deployer.yaml

#
# Deploying the Metric Components
#

# Because deploying and configuring all the metric components is handled by the
# Metrics Deployer, you can simply deploy everything in one step. The "oc
# process" Transform a project template into a project configuration file. This
# command extract the "metrics-deployer-template" we modify on the fly the
# necessary variables and pass this modified template to create "oc create".
# Note: The output of the process command is always a list of one or more
# resources. You may pipe the output to the create command over STDIN 
# (using the '-f -' option) or redirect it to a file. Such as we are doing in
# the next step.

# Note:
# - To list the deployer templates availables in openshift namespace:
#   oc get templates -n openshift | grep deployer
# - To edit the template for metrics deployer:
#   oc edit template metrics-deployer-template -n openshift

#oc process metrics-deployer-template \
#   -n openshift \
#   -v HAWKULAR_METRICS_HOSTNAME=metrics.apps.microserviceslab.com \
#   -v USE_PERSISTENT_STORAGE=true \
#   -v CASSANDRA_PV_SIZE=20Gi | oc create -n openshift-infra -f - 

# notes: https://bugzilla.redhat.com/show_bug.cgi?id=1322275

# cp /usr/share/ansible/openshift-ansible/roles/openshift_hosted_templates/files/v1.4/enterprise/metrics-deployer.yaml .
oc process -f metrics-deployer.yaml \
    -v HAWKULAR_METRICS_HOSTNAME=metrics.apps.microserviceslab.com \
    -v USE_PERSISTENT_STORAGE=true \
    -v CASSANDRA_PV_SIZE=20Gi \
    | oc create -f -

# The OpenShift Enterprise web console uses the data coming from the Hawkular
# Metrics service to display its graphs. The URL for accessing the Hawkular
# Metrics service must be configured via the metricsPublicURL option in the
# master configuration file (/etc/origin/master/master-config.yaml). This URL
# corresponds to the route created with the HAWKULAR_METRICS_HOSTNAME template
# parameter during the deployment of the metrics components.
# ...
# assetConfig:
#   ...
#   metricsPublicURL: "https://metrics.cloudapps.redhat.lan/hawkular/metrics"
#   servingInfo:
# ...
#

# REMEMBER: systemctl restart atomic-openshift-master


