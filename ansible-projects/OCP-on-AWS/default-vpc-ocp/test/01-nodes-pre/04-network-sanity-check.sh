ansible -i ocp_inventory all -m ping
sleep 3
ansible-playbook -i ocp_inventory /usr/share/ansible/openshift-ansible/playbooks/byo/openshift_facts.yml | grep internal_hostnames -A 2
