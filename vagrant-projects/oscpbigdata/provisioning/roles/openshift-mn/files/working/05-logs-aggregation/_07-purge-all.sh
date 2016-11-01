oc delete all --selector logging-infra=kibana
oc delete all --selector logging-infra=elasticsearch
oc delete secret logging-fluentd logging-elasticsearch logging-kibana logging-kibana-proxy
oc delete pv elasticsearch-volume
oc delete pvc logging-es-1
oc delete configmap logging-curator logging-deployer logging-elasticsearch logging-fluentd 
oc delete svc logging-es logging-es-cluster logging-es-ops logging-es-ops-cluster
oc delete svc/logging-kibana
oc delete svc/logging-kibana-ops
oc delete dc/logging-curator
oc delete pod --all -n logging
oc delete serviceaccounts logging-deployer aggregated-logging-kibana aggregated-logging-elasticsearch aggregated-logging-fluentd aggregated-logging-curator
oc delete role oauth-editor 
oc delete role daemonset-admin
oc delete rolebinding logging-deployer-edit-role logging-deployer-dsadmin-role
