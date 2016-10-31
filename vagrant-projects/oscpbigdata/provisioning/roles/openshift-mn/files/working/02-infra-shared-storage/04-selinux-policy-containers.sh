# By policy default, containers cannot write to NFS-mounted directories. Run
# the following to allow containers to write to NFS-mounted directories on all
# the nodes where the pod could land (the infra node for infra pods, and the
# regular nodes, primary for application pods):


source ../01-infra-setup/00-hostnames

hosts="${HOST_MASTER} \
${HOST_NODE1} \
${HOST_NODE2} \
${HOST_NODE3}"

for node in $hosts; do
	echo "Executing in -> $node"
    ssh $node "setsebool -P virt_use_nfs 1;"
    ssh $node "setsebool -P virt_sandbox_use_nfs 1;"
done

# Note:
#
# The -P option above makes the bool persistent between reboots.
# The virt_use_nfs boolean is defined by the docker-selinux package. If an
# error is seen indicating that this bool is not defined, ensure this package
# has been installed.

# Troubleshooting:
#
# [root@ose-node1 ~]# mount -v -t nfs4 <server>:/var/export/pvs/pv1 /mnt/
#
# - Checking RPC problems:
#
# rpcdebug -m rpc all # sets all debug flags for RPC
# rpcdebug -m rpc -c all    # clears all debug flags for RPC
# 
# rpcdebug -m nfsd -s all   # sets all debug flags for NFS Server
# rpcdebug -m nfsd -c all   # clears all debug flags for NFS Server
# 
# journalctl -fl
# 
# rpcinfo -p ose-mn.redhat.lan
# 
# - Checking SELinux problems:
#
# yum install setroubleshoot-server
# sealert -a /var/log/audit/audit.log > mylogfile.txt
# 
# - Checking the services:
#
# systemctl status rpcbind
# systemctl status nfs-server
# systemctl status nfs-lock
# systemctl status nfs-idmap
#
# - Capture a tcpdump of the mount operation:
# 
# mount -t nfs -vvvv server.example.com:/share /mnt/nfs
# tcpdump -s0 -i INTERFACE host NFS.SERVER.IP -w /tmp/tcpdump.pcap 


