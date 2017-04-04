source ./00-hostnames

mkdir -p etc/named/zones
mkdir -p etc/dhcp

tee etc/named.conf <<! 
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

tee etc/named/named.conf.local <<! 
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


tee etc/named/zones/db.${DOMAIN} <<!
\$TTL    604800
@       IN      SOA     ${HOST_EXTERNAL}. admin.${DOMAIN}. (
             3          ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL

; name servers - NS records
    IN      NS      ${HOST_MN}.

; name servers - A records
${HOST_EXTERNAL}.   IN      A       ${IP_EXTERNAL}

; 192.168.121.0/24 - A records
dcos-cluster.${DOMAIN}.  IN A ${IP_EXTERNAL} ; for load balancing
${HOST_BOOTSTRAP}.       IN A ${IP_BOOTSTRAP}
${HOST_MASTER1}.  IN A ${IP_MASTER1}
${HOST_PRIVATE1}.  IN A ${IP_PRIVATE1}
${HOST_PRIVATE2}.  IN A ${IP_PRIVATE2}
${HOST_PUBLIC1}.  IN A ${IP_PUBLIC1}
${HOST_PUBLIC2}.  IN A ${IP_PUBLIC2}
!

tee etc/named/zones/db.${IP_REV} <<!
\$TTL 604800 ; 1 week
@ IN SOA ${HOST_EXTERNAL}. admin.${DOMAIN}. (
    3         ; Serial
    604800    ; Refresh
    86400     ; Retry
    2419200   ; Expire
    604800 )  ; Negative Cache TTL

; name servers
@    IN      NS     ${HOST_EXTERNAL}. 

; PTR Records
${IP_EXTERNAL_INV} IN        PTR     dcos-cluster.${DOMAIN}. 
${IP_EXTERNAL_INV} IN        PTR     ${HOST_EXTERNAL}. 
${IP_BOOTSTRAP_INV} IN        PTR     ${HOST_BOOTSTRAP}. 
${IP_MASTER1_INV} IN        PTR     ${HOST_MASTER1}.     
${IP_PRIVATE1_INV} IN        PTR     ${HOST_PRIVATE1}.     
${IP_PRIVATE2_INV} IN        PTR     ${HOST_PRIVATE2}.     
${IP_PUBLIC1_INV} IN        PTR     ${HOST_PUBLIC1}.     
${IP_PUBLIC2_INV} IN        PTR     ${HOST_PUBLIC2}.     
!

tee etc/named/zones/db.cloudapps.${DOMAIN} <<!
\$ORIGIN  .

\$TTL 1  ;  1 seconds (for testing only)

cloudapps.${DOMAIN} IN  SOA  dcos-cluster.cloudapps.${DOMAIN}. root.cloudapps.${DOMAIN}. (
  2011112904  ; serial
  60          ; refresh (1 minute)
  15          ; retry (15 seconds)
  1800        ; expire (30 minutes)
  10          ; minimum (10 seconds)
)

; the prepend space is important here!
      NS dcos-cluster.cloudapps.${DOMAIN}.

\$ORIGIN cloudapps.${DOMAIN}.

; OpenShift Container Platform router host, or load balancer.
test  A  ${IP_EXTERNAL} 
*     A  ${IP_EXTERNAL} 
!

tee etc/dhcp/dhclient.conf <<!
# The custom DNS server IP
prepend domain-name-servers ${IP_EXTERNAL};
!

