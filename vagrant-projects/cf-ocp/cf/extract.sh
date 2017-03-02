echo "Downloading VirtualBox Vagrant Box for ManageIQ Appliance"
#wget https://atlas.hashicorp.com/manageiq/boxes/euwe/versions/5.1.0/providers/virtualbox.box
echo "Downloading script for qcow2 image into a vagrant-libvirt reusable box"
#wget https://raw.githubusercontent.com/vagrant-libvirt/vagrant-libvirt/master/tools/create_box.sh
echo "Unpacking Vagrant Box"
#tar xvf virtualbox.box
echo "Converting VMDK disk to QCOW2 format"
#qemu-img convert CentOS-7.2.vmdk -O qcow2 manageiq.qcow2
#qemu-img convert CentOS-7.2.vmdk -O raw manageiq.img
echo "Clean up virtualbox.box file"
# rm -f virtualbox.box
echo "Installing virt utils"
#sudo dnf install virt-install virt-viewer -y
# osinfo-query os | grep centos

sudo virt-install \
    -n manageiq \
    --description "hola" \
    --os-type Linux \
    --os-variant centos7.0 \
    --ram 8196 \
    --vcpus 2 \
    --disk /var/lib/libvirt/images/manageiq.qcow2,bus=virtio,size=50 \
    --import

# sh create_box.sh CentOS-7.2.qcow2 
# vagrant box add manageiq.box --name manageiq

# sudo virsh destroy manageiq
# sudo virsh undefine manageiq

