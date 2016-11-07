source ./00-hostnames

hosts="${HOST_MASTER} \
${HOST_NODE1} \
${HOST_NODE2} \
${HOST_NODE3} \
${HOST_NODE4}"

echo "distributing file ...."

for node in $hosts; do
	echo "Copy to -> $node"
	scp $1 root@$node:$2/$1
done
