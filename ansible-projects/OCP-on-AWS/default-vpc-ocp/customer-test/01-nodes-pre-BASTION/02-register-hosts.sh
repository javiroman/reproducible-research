#ansible \
#	-i inventory infra,apps \
#	-m command \
#	-a "subscription-manager unregister"
#ansible \
#	-i inventory infra,apps \
#	-m command \
#	-a "subscription-manager clean"

ansible -i inventory infra,apps -m command -a "subscription-manager register --username=rovira.joel@sabis.tech --password=XXX"
ansible -i inventory infra,apps -m command -a "sudo subscription-manager attach --pool=AAAAA"
ansible -i inventory infra,apps -m command -a "subscription-manager repos --disable='*'"
ansible -i inventory infra,apps -m command -a "subscription-manager repos --enable='rhel-7-server-rpms' --enable='rhel-7-server-extras-rpms' --enable='rhel-7-server-ose-3.4-rpms'"

