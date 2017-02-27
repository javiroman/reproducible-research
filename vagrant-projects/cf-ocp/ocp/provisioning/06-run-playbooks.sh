ansible-playbook -i inventory playbooks/01-install-base-packages.yml
ansible-playbook -i inventory playbooks/02-selinux-enforcing.yml
ansible-playbook -i inventory playbooks/03-insecure-registry.yml
ansible-playbook -i inventory playbooks/04-docker-storage-config.yml
ansible-playbook -i inventory playbooks/05-docker-storage-setup.yml
ansible-playbook -i inventory playbooks/06-check-docker-storage.yml
ansible-playbook -i inventory playbooks/07-start-docker-daemon.yml
ansible-playbook -i inventory playbooks/08-start-docker-daemon.yml

#ansible-playbook -i inventory playbooks/reboot-systems.yml
