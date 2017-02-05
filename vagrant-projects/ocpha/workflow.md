The following steps are common tasks for OpenShift deployments.

# Deploy Infrastructure

1. **step-0**: Virtualization or Cloud Provider Deploy

 Deployment of virtualization infrastructure (Vagrant-libvirt) or cloud provider
 such as AWS.

2. **step-1**: Virtualization or Cloud Provider Check

 Checking of virtualization infra (Vagrant-libvirt) or cloud provider ifra (ASW)

3. **step-2**: OCP Pre-Deploy 

 Typically a custom Ansible playbook for pre-deployment OCP tasks.

4. **step-3**: OCP Pre-Check (Ansible Playbook)

 Custom ansible playbook or provided playbooks for checking pre-requisites.

5. **step-4**: OCP Deploy 

 Official OCP Ansible Playbook.

6. **step-5**: OCP Check (Ansible Playbook)

 Custom ansible playbook for overall checking of OCP deployment.

# Scale Infrastructure

# Decommission Infrastructure and Object Pruning
