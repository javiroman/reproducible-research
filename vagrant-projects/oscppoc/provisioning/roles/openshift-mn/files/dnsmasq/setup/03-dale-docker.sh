sudo yum -y install docker -y
sudo sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --log-driver=journald --insecure-registry 172.30.0.0/16"' /etc/sysconfig/docker
cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/vdb
VG=docker-vg
EOF
docker-storage-setup
lsblk
systemctl start docker
systemctl enable docker
docker info
