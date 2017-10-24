#oc login -u system:admin 
#oc project default &> /dev/null

echo "Master -->"
oc adm manage-node ip-10-0-0-155.eu-west-1.compute.internal --list-pods
echo 
echo "Infra -->"
oc adm manage-node ip-10-0-0-193.eu-west-1.compute.internal --list-pods
echo 
echo "App1 -->"
oc adm manage-node ip-10-0-0-60.eu-west-1.compute.internal --list-pods
echo 
echo "App2 -->"
oc adm manage-node ip-10-0-0-207.eu-west-1.compute.internal --list-pods
