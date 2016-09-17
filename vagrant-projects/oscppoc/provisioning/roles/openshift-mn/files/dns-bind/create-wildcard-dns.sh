#!/bin/bash

#guid=`hostname|cut -f2 -d-|cut -f1 -d.`
yum -y install bind bind-utils
systemctl enable named
systemctl stop named

### firewalld was being a bit problematic
### Since we turn it off later anyway, I've skipped this step.
#firewall-cmd --permanent --zone=public --add-service=dns
#firewall-cmd --reload
#sleep 100;

#master00-$guid.oslab.opentlc.com
#masterIP=`host infranode00-$guid.oslab.opentlc.com ipa.opentlc.com  | grep $guid | awk '{ print $4 }'`
masterIP=`host ose-node1.redhat.lan | awk '{ print $4 }'`

domain="cloudapps-redhat.lan"

echo master ip is $masterIP | tee -a /root/.dns.installer.txt
echo domain  is $domain | tee -a /root/.dns.installer.txt

rm -rf /var/named/zones
mkdir -p /var/named/zones

echo "\$ORIGIN  .
\$TTL 1  ;  1 seconds (for testing only)
${domain} IN SOA master.${domain}.  root.${domain}.  (
  2011112904  ;  serial
  60  ;  refresh (1 minute)
  15  ;  retry (15 seconds)
  1800  ;  expire (30 minutes)
  10  ; minimum (10 seconds)
)
  NS master.${domain}.
\$ORIGIN ${domain}.
test A ${masterIP}
* A ${masterIP}"  >  /var/named/zones/${domain}.db

chgrp named -R /var/named
chown named -R /var/named/zones
restorecon -R /var/named

echo "// named.conf
options {
  listen-on port 53 { any; };
  directory \"/var/named\";
  dump-file \"/var/named/data/cache_dump.db\";
  statistics-file \"/var/named/data/named_stats.txt\";
  memstatistics-file \"/var/named/data/named_mem_stats.txt\";
  allow-query { any; };
  recursion yes;
  /* Path to ISC DLV key */
  bindkeys-file \"/etc/named.iscdlv.key\";
};
logging {
  channel default_debug {
    file \"data/named.run\";
    severity dynamic;
  };
};
zone \"${domain}\" IN {
  type master;
  file \"zones/${domain}.db\";
  allow-update { key ${domain} ; } ;
};" > /etc/named.conf

chown root:named /etc/named.conf
restorecon /etc/named.conf

systemctl start named

dig @127.0.0.1 test.cloudapps-redhat.lan

if [ $? = 0 ]
then
  echo "DNS Setup was successful!"
else
  echo "DNS Setup failed"
fi

echo Fully Finished the $0 script  | tee -a /root/.dns.installer.txt

yum install ipatables-service -y
systemctl stop firewalld

systemctl disable firewalld

iptables -I INPUT -p tcp --dport 53 -j ACCEPT
iptables -I INPUT -p udp --dport 53 -j ACCEPT
iptables-save
