# Stardard DC/OS Testbed

This project tackle a full working DC/OS test environment based on Vagrant.

# Requeriments

This project was tested in Fedora 24 system with the following utilities:

```
$ sudo dnf install vagrant vagrant-libvirt ansible -y
```

```
$ vagrant version
Installed Version: 1.8.5
Latest Version: 1.9.3

$ vagrant plugin list
vagrant-libvirt (0.0.35, system)

$ ansible --version
ansible 2.2.1.0
```

# Execution

This test was run in a Intel(R) Core(TM) i7-6500U CPU @ 2.50GHz with 16GiB.

```
time vagrant up
[...]
real    23m12.764s
user    9m37.775s
sys     1m9.542s

```
# TODO

1. Improving the timeout in long download tasks. The dependents tasks must be
   reworked in order to use notify and handlers.

2. Create operations folder with playbook for health checking.







