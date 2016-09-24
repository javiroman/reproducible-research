$TTL    604800
@       IN      SOA     oscppoc-master.ocp.example.com. oscppoc-master.ocp.example.com. (
             3          ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL

; name servers - NS records
    IN      NS      oscppoc-master.ocp.example.com.

; name servers - A records
oscppoc-master.ocp.example.com.          IN      A       192.168.121.58

; 192.168.121.0/24 - A records
oscppoc-node1.ocp.example.com.  IN A 192.168.121.196
oscppoc-node2.ocp.example.com.  IN A 192.168.121.144

openshift-cluster.redhat.lan.   IN A 192.168.122.54  
ose-mn.redhat.lan.              IN A 192.168.122.232 
ose-lb.redhat.lan.              IN A 192.168.122.54
ose-master1.redhat.lan.         IN A 192.168.122.245 
ose-master2.redhat.lan.         IN A 192.168.122.251 
ose-master3.redhat.lan.         IN A 192.168.122.227
ose-node1.redhat.lan.           IN A 192.168.122.221 
ose-node2.redhat.lan.           IN A 192.168.122.49  
ose-node3.redhat.lan.           IN A 192.168.122.6  


