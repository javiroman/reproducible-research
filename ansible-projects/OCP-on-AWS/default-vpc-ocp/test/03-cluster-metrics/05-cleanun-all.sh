# You can remove everything deloyed by the metrics deployer by performing the following steps:

oc delete all,secrets,sa,templates,pvc --selector="metrics-infra" -n openshift-infra

# To remove the deployer components, perform the following steps:
oc delete sa,secret metrics-deployer -n openshift-infra
