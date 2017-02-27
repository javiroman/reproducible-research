#subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.4-rpms"
sudo yum update -y
yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion -y
yum install vim tree policycoreutils policycoreutils-python selinux-policy selinux-policy-targeted libselinux-utils setroubleshoot-server setools-console mcstrans -y
yum install atomic-openshift-utils -y
yum install atomic-openshift-excluder atomic-openshift-docker-excluder -y
atomic-openshift-excluder unexclude
