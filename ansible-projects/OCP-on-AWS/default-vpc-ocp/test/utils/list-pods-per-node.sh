#oc login -u system:admin 
#oc project default &> /dev/null

oc adm manage-node ip-172-31-46-214.eu-west-1.compute.internal --list-pods
oc adm manage-node ip-172-31-29-89.eu-west-1.compute.internal --list-pods

oc adm manage-node ip-172-31-27-85.eu-west-1.compute.internal --list-pods
oc adm manage-node ip-172-31-24-131.eu-west-1.compute.internal --list-pods
