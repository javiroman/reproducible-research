sudo grep htpasswd /etc/origin/master/master-config.yaml
sudo htpasswd -c /etc/origin/master/htpasswd administrador
sudo htpasswd /etc/origin/master/htpasswd user01

# Make user cluster admin
oc adm policy add-cluster-role-to-user cluster-admin administrador

# The users are visible with the first login
oc get users
oc get identity

