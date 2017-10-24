# - Deletes the specified VPC. You must detach or delete all gateways and
# resources that are associated with the VPC before you can delete it. For
# example, you must terminate all instances running in the VPC, delete all
# security groups associated with the VPC (except the default one), delete all
# route tables associated with the VPC (except the default one), and so on.

echo "Deleting VPC: $AWS_VPC"
aws ec2 delete-vpc --vpc-id $AWS_VPC
