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

; 10.128.0.0/16 - A records
oscppoc-node1.ocp.example.com.        IN      A      192.168.121.196
oscppoc-node2.ocp.example.com.        IN      A      192.168.121.144

