sudo subscription-manager register --username rovira.joel@sabis.tech 
sudo subscription-manager list --available &> skus.txt
sudo subscription-manager attach --pool=AAAA
sudo subscription-manager repos --disable "*"
sudo subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.4-rpms"
sudo yum install tree vim wget git net-tools bind-utils iptables-services bridge-utils bash-completion -y
sudo yum install atomic-openshift-utils -y 
sudo yum install atomic-openshift-excluder atomic-openshift-docker-excluder -y
sudo atomic-openshift-excluder unexclude
