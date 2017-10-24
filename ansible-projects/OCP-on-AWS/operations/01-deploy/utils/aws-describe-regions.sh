#!/bin/env bash
# Note: To set the default region for EC2 command:
#   export AWS_DEFAULT_REGION=eu-west-1

#source $FUNCTIONS

#usage "hola"

echo "Documented Regions"
echo "------------------"
echo "us-east-1 US East (N. Virginia)"
echo "us-east-2 US East (Ohio)"
echo "us-west-1 US West (N. California)"
echo "us-west-2 US West (Oregon)"
echo "ca-central-1 Canada (Central)"
echo "eu-west-1 EU (Ireland)"
echo "eu-central-1 EU (Frankfurt)"
echo "eu-west-2 EU (London)"
echo "ap-northeast-1 Asia Pacific (Tokyo)"
echo "ap-northeast-2 Asia Pacific (Seoul)"
echo "ap-southeast-1 Asia Pacific (Singapore)"
echo "ap-southeast-2 Asia Pacific (Sydney)"
echo "ap-south-1 Asia Pacific (Mumbai)"
echo "sa-east-1 South America (São Paulo)"

echo "Live Available Regions"
echo "----------------------"
aws ec2 describe-regions | jq ".Regions[] | .RegionName"
