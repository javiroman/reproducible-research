for node in oscppoc-master.example.com \
	oscppoc-node1.example.com  \
	oscppoc-node2.example.com; do
	
	scp $1 root@$node:$1
done

echo "copied file ..."
