source ./00-hostnames

sudo yum install bind -y

sudo mv -f /etc/named.conf /etc/named.conf.ORI
sudo mkdir /etc/named/zones

sudo tee /etc/named.conf <<! 
options {
	listen-on port 53 { any; };
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
	statistics-file "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";
	allow-query     { any; };
	querylog yes;

	/* 
	 - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
	 - If you are building a RECURSIVE (caching) DNS server, you need to enable 
	   recursion. 
	 - If your recursive DNS server has a public IP address, you MUST enable access 
	   control to limit queries to your legitimate users. Failing to do so will
	   cause your server to become part of large scale DNS amplification 
	   attacks. Implementing BCP38 within your network would greatly
	   reduce such attack surface 
	*/
	recursion yes;

	dnssec-enable yes;
	dnssec-validation yes;

	/* Path to ISC DLV key */
	bindkeys-file "/etc/named.iscdlv.key";

	managed-keys-directory "/var/named/dynamic";

	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
	type hint;
	file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";

/* 
 * custom
 */
include "/etc/named/named.conf.local";
!

sudo tee /etc/named/named.conf.local <<! 
zone "${DOMAIN}" IN {
    type master;
    file "/etc/named/zones/db.${DOMAIN}"; 
};

zone "${IP_INV}.in-addr.arpa" IN {
    type master;
    file "/etc/named/zones/db.${IP_REV}"; 
};

zone "cloudapps.${DOMAIN}" IN { 
    type master;
    file "/etc/named/zones/db.cloudapps.${DOMAIN}";
    allow-update { key cloudapps.${DOMAIN} ; } ; 
};
!


sudo tee /etc/named/zones/db.${DOMAIN} <<!
\$TTL    604800
@       IN      SOA     ${HOST_MN}. admin.${DOMAIN}. (
             3          ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL

; name servers - NS records
    IN      NS      ${HOST_MN}.

; name servers - A records
${HOST_MN}.   IN      A       ${IP_MN}

; 192.168.121.0/24 - A records
openshift-cluster.${DOMAIN}.  IN A ${IP_MASTER}
${HOST_MASTER}.  IN A ${IP_MASTER}
${HOST_NODE1}.  IN A ${IP_NODE1}
${HOST_NODE2}.  IN A ${IP_NODE2}
${HOST_NODE3}.  IN A ${IP_NODE3}
!

sudo tee /etc/named/zones/db.${IP_REV} <<!
\$TTL 604800 ; 1 week
@ IN SOA ${HOST_MN}. admin.${DOMAIN}. (
    3         ; Serial
    604800    ; Refresh
    86400     ; Retry
    2419200   ; Expire
    604800 )  ; Negative Cache TTL

; name servers
@    IN      NS     ${HOST_MN}. 

; PTR Records
${IP_MASTER_INV} IN        PTR     openshift-cluster.${DOMAIN}. 
${IP_MN_INV} IN        PTR     ${HOST_MN}. 
${IP_MASTER_INV} IN        PTR     ${HOST_MASTER}.     
${IP_NODE1_INV} IN        PTR     ${HOST_NODE1}.     
${IP_NODE2_INV} IN        PTR     ${HOST_NODE2}.     
${IP_NODE3_INV} IN        PTR     ${HOST_NODE3}.     
!

sudo tee /etc/named/zones/db.cloudapps.${DOMAIN} <<!
\$ORIGIN  .

\$TTL 1  ;  1 seconds (for testing only)

cloudapps.${DOMAIN} IN  SOA  openshift-cluster.cloudapps.${DOMAIN}. root.cloudapps.${DOMAIN}. (
  2011112904  ; serial
  60          ; refresh (1 minute)
  15          ; retry (15 seconds)
  1800        ; expire (30 minutes)
  10          ; minimum (10 seconds)
)

; the prepend space is important here!
      NS openshift-cluster.cloudapps.${DOMAIN}.

\$ORIGIN cloudapps.${DOMAIN}.

; OpenShift Container Platform router host, or load balancer.
test  A  ${IP_NODE1} 
*     A  ${IP_NODE1} 
!

sudo tee /etc/dhcp/dhclient.conf <<!
# The custom DNS server IP
prepend domain-name-servers ${IP_MN};
!

sudo systemctl start named
sudo systemctl enable named
sudo systemctl restart NetworkManager
