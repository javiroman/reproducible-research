ansible -i inventory -m ping all

# 1. Copy /etc/hosts file to the entire cluster.

# ansible -i hosts -i inventory all -m copy -a "src=hosts dest=/tmp/hosts"

# 2. Register all nodes to RH Content Delivery Network (CDN)

# ansible -i inventory lb,masters,registries,nodes -m command -a "subscription-manager register --username=AA --password=AA"
# ansible -i inventory all -m command -a "subscription-manager attach --pool=AA"

# ansible -i inventory all -m command -a "subscription-manager repos --disable='*'" 
# ansible -i inventory all -m command -a "subscription-manager repos --enable='rhel-7-server-rpms' \
#	--enable='rhel-7-server-extras-rpms' \
#	--enable='rhel-7-server-ose-3.4-rpms'"
# ansible -i inventory all -m yum -a "name=vim state=latest"
