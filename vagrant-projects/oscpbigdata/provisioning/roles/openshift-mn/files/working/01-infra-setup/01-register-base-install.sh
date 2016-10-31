#
# Subscription and attaching to customer pool.
#
#sudo subscription-manager register  --username jromanes@redhat.com
sudo subscription-manager attach --pool=8a85f981568e999d01568ed222cd6712                                                                                                                                                

#
# Clean up of unused repos and enabling minimal repos.
#
sudo subscription-manager repos --disable "*"
sudo subscription-manager repos --enable="rhel-7-server-rpms"
sudo subscription-manager repos --enable="rhel-7-server-extras-rpms"
sudo subscription-manager repos --enable="rhel-7-server-ose-3.3-rpms"

#
# Minimal packages for PaaS
#
sudo yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion -y

#
# Standard packages for rhel-7.2 Vagrant box used.
#
sudo yum install vim tree policycoreutils policycoreutils-python selinux-policy selinux-policy-targeted libselinux-utils setroubleshoot-server setools setools-console mcstrans -y

#
# Last sanity update
#
sudo yum update -y

#
# OpenShift Container Platform utilities 
#
sudo yum install atomic-openshift-utils -y

#
# Prerequisites SELinux and local Firewall
#
sudo sed -i 's/permissive/enforcing/g' /etc/selinux/config

#
# Host restart
#
# sudo systemctl reboot
