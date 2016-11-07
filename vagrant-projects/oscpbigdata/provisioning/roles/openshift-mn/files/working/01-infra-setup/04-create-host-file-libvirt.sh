source ./00-hostnames

cat <<! > hosts
127.0.0.1   oscpbigdata-mn localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
$IP_MN 	$HOST_MN $MN
$IP_MASTER $HOST_MASTER $MASTER
$IP_NODE1  $HOST_NODE1 $NODE1
$IP_NODE2  $HOST_NODE2 $NODE2
$IP_NODE3  $HOST_NODE3 $NODE3
$IP_NODE4  $HOST_NODE3 $NODE4
!



