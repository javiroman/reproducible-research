# ansible -i inventory infra,apps -m command -a "subscription-manager register --username=jromanes@redhat.com --password=Python1bich@"
# ansible -i inventory infra,apps -m command -a "sudo subscription-manager attach --pool=8a85f98159eeb53d0159ef8620fd4684"
# ansible -i inventory infra,apps -m command -a "subscription-manager repos --disable='*'"
# ansible -i inventory infra,apps -m command -a "subscription-manager repos --enable='rhel-7-server-rpms' --enable='rhel-7-server-extras-rpms' --enable='rhel-7-server-ose-3.4-rpms'"

