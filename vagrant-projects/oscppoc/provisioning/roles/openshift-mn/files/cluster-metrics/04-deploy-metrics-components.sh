oc process metrics-deployer-template \
-n openshift \
-v HAWKULAR_METRICS_HOSTNAME=metrics.cloudapps.example.com,\
IMAGE_VERSION=v3.2,\
IMAGE_PREFIX=registry.access.redhat.com/openshift3/,\
USE_PERSISTENT_STORAGE=true,\
CASSANDRA_PV_SIZE=2Gi | oc create -n openshift-infra -f - 

# notes: https://bugzilla.redhat.com/show_bug.cgi?id=1322275

