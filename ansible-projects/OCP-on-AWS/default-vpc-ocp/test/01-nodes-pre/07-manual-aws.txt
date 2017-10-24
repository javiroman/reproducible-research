This setup is for using EBS in our platform.
Typically we can create tree EBS volumes as shared
storage for:

A. Registry
B. Logging
C. Metrics

0. In all hosts!

1. sudo mkdir /etc/aws/

2. sudo vim /etc/aws/aws.conf

[Global]
Zone = us-east-1c 

This is the Availability Zone of your AWS Instance and 
where your EBS Volume resides; this information is 
obtained from the AWS Managment Console.

3. Master configuration:

sudo vim /etc/origin/master/master-config.yaml 

kubernetesMasterConfig:
  ...
  apiServerArguments:
    cloud-provider:
      - "aws"
    cloud-config:
      - "/etc/aws/aws.conf"
  controllerArguments:
    cloud-provider:
      - "aws"
    cloud-config:
      - "/etc/aws/aws.conf"

4. Nodes Configuration:

sudo vim /etc/origin/node/node-config.yaml

kubeletArguments:
  cloud-provider:
    - "aws"
  cloud-config:
    - "/etc/aws/aws.conf"

5. Make sure the following environment variables are set in the 
   /etc/sysconfig/atomic-openshift-master file on masters 
   and the /etc/sysconfig/atomic-openshift-node file on nodes:


AWS_ACCESS_KEY_ID=<key_ID>
AWS_SECRET_ACCESS_KEY=<secret_key>

6. Restart services:

sudo systemctl restart atomic-openshift-master
sudo systemctl restart atomic-openshift-node


IMPORTANT:

Switching from not using a cloud provider to using a cloud provider 
produces an error message. Adding the cloud provider tries to delete 
the node because the node switches from using the hostname as the 
externalID (which would have been the case when no cloud provider 
was being used) to using the AWS instance-id (which is what the 
AWS cloud provider specifies). To resolve this issue:

Log in to the CLI as a cluster administrator.

Delete the nodes:

$ oc delete node <node_name>

IMPORTANT:

Issues -> https://access.redhat.com/solutions/1751123
On each node host, restart the atomic-openshift-node service.


