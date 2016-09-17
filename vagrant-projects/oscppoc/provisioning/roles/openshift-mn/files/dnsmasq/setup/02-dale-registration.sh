subscription-manager register  --username jromanes@redhat.com
subscription-manager attach --pool=8a85f981568e999d01568ed222cd6712
subscription-manager repos --disable "*"
subscription-manager repos --enable=rhel-7-server-rpms
subscription-manager repos --enable=rhel-7-server-rh-common-rpms
subscription-manager repos --enable=rhel-7-server-optional-rpms
subscription-manager repos --enable=rhel-7-server-ose-3.2-rpms
subscription-manager repos --enable=rhel-7-server-extras-rpms 
yum install wget git net-tools bind-utils vim -y
yum install iptables-services bridge-utils bash-completion -y
yum update -y
yum install atomic-openshift-utils -y
sudo yum install policycoreutils policycoreutils-python selinux-policy \
selinux-policy-targeted libselinux-utils setroubleshoot-server setools \
setools-console mcstrans -y
sudo systemctl start firewalld.service
sudo systemctl enable firewalld.service
sudo sed -i 's/permissive/enforcing/g' /etc/selinux/config
setenforce 1

