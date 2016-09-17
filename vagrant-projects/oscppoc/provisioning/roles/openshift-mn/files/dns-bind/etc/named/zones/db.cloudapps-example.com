$ORIGIN  .

$TTL 1  ;  1 seconds (for testing only)

cloudapps-example.com    IN    SOA    osppoc-master.cloudapps-example.com.  root.cloudapps-example.com. (
  2011112904  ; serial
  60          ; refresh (1 minute)
  15          ; retry (15 seconds)
  1800        ; expire (30 minutes)
  10          ; minimum (10 seconds)
)

NS osppoc-master.cloudapps-example.com.

$ORIGIN cloudapps-example.com.

test A 192.168.121.58
* A  192.168.121.58
