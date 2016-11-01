source 01-infra-setup/00-hostnames

oc login -u system:admin 
oc project default &> /dev/null

oc adm manage-node $HOST_MASTER --list-pods
oc adm manage-node $HOST_NODE1 --list-pods
oc adm manage-node $HOST_NODE2 --list-pods
oc adm manage-node $HOST_NODE3 --list-pods
