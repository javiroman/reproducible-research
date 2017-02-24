vagrant ssh-config > /tmp/ssh-config.dat

host_list=$(cat /tmp/ssh-config.dat | grep ^Host | cut -d' ' -f2)

echo "[all:vars]" > inventory
echo "ansible_ssh_user=vagrant" >> inventory
echo "ansible_become=yes" >> inventory
echo "[hosts]" >> inventory
for i in $host_list; do
    echo -ne "$i ansible_ssh_private_key_file=.vagrant/machines/$i/libvirt/private_key ansible_host="
    cat /tmp/ssh-config.dat | grep -A 1 "^Host ${i}$" | grep HostName | cut -d' ' -f4
done >> inventory

rm /tmp/ssh-config.dat

# http://stackoverflow.com/questions/32297456/how-to-ignore-ansible-ssh-authenticity-checking
