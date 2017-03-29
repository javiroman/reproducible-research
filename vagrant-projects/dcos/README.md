# Stardard DC/OS Testbed

This project tackle a full working DC/OS test environment based on Vagrant.

# Requeriments

This project was tested in Fedora 24 system with the following utilities:

```
$ sudo dnf install vagrant vagrant-libvirt ansible -y
```
For other systems you will need at least the following tool versions:

```
$ vagrant version
Installed Version: 1.8.5
Latest Version: 1.9.3

$ vagrant plugin list
vagrant-libvirt (0.0.35, system)

$ ansible --version
ansible 2.2.1.0
```
## For Ubuntu desktop users

```
wget https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.deb
sudo dpkg -i vagrant_1.8.4_x86_64.deb
sudo apt-get update

sudo apt-get install qemu-kvm libvirt-bin libvirt-dev
sudo adduser $USER libvirtd
sudo usermod -G libvirt -a $USER

sudo add-apt-repository ppa:ansible/ansible 
sudo apt-get --only-upgrade install ansible

vagrant up --provider=libvirt

```

# Execution

This test was run in a Intel(R) Core(TM) i7-6500U CPU @ 2.50GHz with 16GiB.

```
time vagrant up
[...]
real    18m46.697s
user    8m4.940s
sys     0m51.935s
```
![DC/OS Dashboard](https://github.com/javiroman/reproducible-research/blob/master/vagrant-projects/dcos/img/dashboard.png)

# Testing

From boot machine:

```
$ vagrant ssh boot
$ dcos auth login

Please go to the following link in your browser:

    http://m1/login?redirect_uri=urn:ietf:wg:oauth:2.0:oob
OpenID Connect ID Token: .....
Login successful!

$ dcos node
  HOSTNAME         IP                          ID                    
100.0.10.102  100.0.10.102  88b2713d-af8f-4026-8c8b-ab7745f5523c-S0  
100.0.10.103  100.0.10.103  88b2713d-af8f-4026-8c8b-ab7745f5523c-S1  
100.0.10.104  100.0.10.104  3cde9319-810a-4afa-8b82-851f9e84895e-S0 
```

Running a Docker based application (similar to docker run):

```
$ dcos marathon app add https://dcos.io/docs/latest/usage/nginx.json
Created deployment eea68324-c9b3-47da-9689-5b73b00a4eb5
$ dcos marathon app list
ID      MEM   CPUS   TASKS  HEALTH  DEPLOYMENT  WAITING  CONTAINER  CMD                         
/nginx  128  0.0625   1/1    ---       ---      False      DOCKER   None                        
$ curl -O https://raw.githubusercontent.com/mesosphere/marathon/master/examples/labels.json
$ dcos marathon app add labels.json 
Created deployment 2f2d0add-247e-457c-80d3-2c73fec30841
$ $ dcos marathon app list 
ID       MEM  CPUS  TASKS  HEALTH  DEPLOYMENT  WAITING  CONTAINER  CMD                               
/nginx   128  0.0625   1/1    ---       ---      False      DOCKER   None                        
/labels  50   0.1      1/1    ---       ---      False      mesos    python -m SimpleHTTPServer $PORT  
```


