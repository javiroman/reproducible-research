# Apache Spark Standalone Cluster

In addition to running on the Mesos or YARN cluster managers, Spark also 
provides a simple standalone deploy mode.

This Vagrantfile run a Apache Spark Standalone Cluster:

- One master node for the standalone cluster manager
- The workers nodes are setup by the env-setup file.
- WARNING: take a look to comment at "vim +44 Vagrantfile"

```
.
├── env-setup
├── provisioning
│   ├── ansible.cfg
│   ├── roles
│   │   ├── common
│   │   ├── spark-mn
│   │   ├── spark-master
│   │   └── spark-worker
│   └── site.yml
├── README.md
└── Vagrantfile
```

TODO

- private network (2nd interface with static network)
- spark management node with Jupyter, and Zeppelin notebooks
- better DNS mecanish, to avoid setup the host names in the 
  host file of host machine. (libvirtd dnsmasq inject /etc/host
  file from host machine to the guests)
