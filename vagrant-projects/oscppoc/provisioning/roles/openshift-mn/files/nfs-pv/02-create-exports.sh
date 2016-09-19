# - root_squash: Map requests from uid/gid 0 to the anonymous uid/gid. By
# default, NFS shares change the root user to the nfsnobody user, an
# unprivileged user account. This changes the owner of all root-created files
# to nfsnobody, which prevents uploading of programs with the setuid bit set.
#
# If I create a file as the root user on the client on the NFS share, by default
# that file is owned by the nobody user.
#
# root@client:~# touch /shared/nfs1/file2 
# root@server:/nfs1# ls -la file2
#  -rw-r--r-- 1 nfsnobody nfsnobody 0 Nov 18 18:06 file2
#
# - all_squash: Map all uids and gids to the anonymous user. So convert incoming
#  requests, from ALL users, to the anonymous uid and gid.

# creating folder for PV exports
mkdir -p /var/export/pvs/pv{1..10}
mkdir -p /var/export/pvs/registry-storage
chown -R nfsnobody:nfsnobody /var/export/pvs/
chmod -R 777 /var/export/pvs/

# pupulating /etc/exports
for volume in pv{1..10} ; do
        echo Creating export for volume $volume;
            echo "/var/export/pvs/${volume}
            192.168.121.0/24(rw,sync,no_root_squash)" >> /etc/exports;
done

echo "/var/exports/pvs/registry-storage
192.168.121.0/24(rw,sync,no_root_squash)" >> /etc/exports
