Apache Spark Standalone simple cluster manager.

In addition to running on the Mesos or YARN cluster managers, Spark also 
provides a simple standalone deploy mode.

This Vagrantfile run a Apache Spark Standalone Cluster:
	- One master node for the standalone cluster manager
	- The workers nodes are setup by the env-setup file.
	- WARNING: take a look to comment at "vim +44 Vagrantfile"
