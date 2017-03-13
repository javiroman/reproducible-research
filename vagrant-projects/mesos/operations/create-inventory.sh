INVENTORY=.vagrant/inventory
SSH_CONF_TEMP=/tmp/ssh-config.dat
vagrant ssh-config > $SSH_CONF_TEMP

host_list=$(cat /tmp/ssh-config.dat | grep ^Host | cut -d' ' -f2)

echo "[all:vars]" > $INVENTORY
echo "ansible_ssh_user=vagrant" >> $INVENTORY
echo "ansible_become=yes" >> $INVENTORY
echo "[hosts]" >> $INVENTORY
for i in $host_list; do
    echo -ne "$i ansible_ssh_private_key_file=.vagrant/machines/$i/libvirt/private_key ansible_host="
    cat $SSH_CONF_TEMP | grep -A 1 "^Host ${i}$" | grep HostName | cut -d' ' -f4
done >> $INVENTORY

rm $SSH_CONF_TEMP

echo "checking external inventorhy"
ansible -i .vagrant/inventory all -m ping
