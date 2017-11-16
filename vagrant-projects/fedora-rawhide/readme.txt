Instructions from:
~~~~~~~~~~~~~~~~~

https://fedoraproject.org/wiki/DNF_system_upgrade

https://app.vagrantup.com/fedora
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vagrant init fedora/27-cloud-base   --box-version 20171105
vagrant up
vagrant ssh 

sudo dnf upgrade --refresh -y
sudo dnf install dnf-plugin-system-upgrade -y
sudo dnf system-upgrade download --refresh --nogpgcheck --releasever=rawhide -y

# If we are working with stable fedora 27, the Rawhide will be fedora 28, we
# have to import the PGP key, available in this folder.

sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-28-x86_64
sudo dnf system-upgrade reboot
