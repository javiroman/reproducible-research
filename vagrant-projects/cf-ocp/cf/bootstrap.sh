#!/bin/bash +x  

# https://github.com/vagrant-libvirt/vagrant-libvirt/blob/master/tools/prepare_redhat_for_box.sh  
# to fit manageiq

# Users, groups, passwords and sudoers.  
echo 'vagrant' | passwd --stdin root
grep 'vagrant' /etc/passwd > /dev/null
if [ $? -ne 0 ]; then
	echo '* Creating user vagrant.'
	useradd vagrant
	echo 'vagrant' | passwd --stdin vagrant
fi
grep '^admin:' /etc/group > /dev/null || groupadd admin
usermod -G admin vagrant

echo 'Defaults    env_keep += "SSH_AUTH_SOCK"' >> /etc/sudoers
echo '%admin ALL=NOPASSWD: ALL' >> /etc/sudoers
sed -i 's/Defaults\s*requiretty/Defaults !requiretty/' /etc/sudoers

# SSH setup  
# Add Vagrant ssh key for root and vagrant accouts.
sed -i 's/.*UseDNS.*/UseDNS no/' /etc/ssh/sshd_config

#[ -d /root/.ssh ] || mkdir /root/.ssh  
#chmod 700 /root/.ssh  
#cat > /root/.ssh/authorized_keys << EOF
#ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
#EOF
#chmod 600 ~root/.ssh/authorized_keys

#[ -d /home/vagrant/.ssh ] || mkdir /home/vagrant/.ssh
#chmod 700 /home/vagrant/.ssh
#cat > ~vagrant/.ssh/authorized_keys << EOF
#ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
#EOF
#chmod 600 ~vagrant/.ssh/authorized_keys
#chown -R vagrant.vagrant ~vagrant/.ssh/

# Networking setup..  
# Don't fix ethX names to hw address.  
rm -f /etc/udev/rules.d/*persistent-net.rules
rm -f /etc/udev/rules.d/*-net.rules
rm -fr /var/lib/dhclient/*

# Interface eth0 should get IP address via dhcp.  
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
NM_CONTROLLED="no"
EOF

systemctl disable \
	cloud-config.service \
	cloud-final.service \
	cloud-init-local.service \
	cloud-init.service \
	cloud-config.target \
	cloud-ds-check.service

# Do some cleanup..  
rm -f ~root/.bash_history
yum clean all

poweroff
