# Create Image Streams

# The deployer created many resources that rely on several image streams, but
# these image streams do not exist yet. Fortunately, the deployer created a
# template that can create the image streams.

# As a cluster administrator, deploy the logging-support-template template that
# the deployer created:

oc process logging-support-template | oc create -f -
