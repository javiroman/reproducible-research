vagrant ssh-config > /tmp/a.dat

host_list=$(cat /tmp/a.dat | grep ^Host | cut -d' ' -f2)

echo "[all:vars]" > file
for i in $host_list; do
    echo -ne "$i ansible_host="
    cat /tmp/a.dat | grep -A 1 "^Host ${i}$" | grep HostName | cut -d' ' -f4
done >> file

rm /tmp/a.dat
