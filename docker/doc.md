# How works the docker container

## Corefile

- Every bracketed section is a DNS zone
- `.` stands for gobal, so `.:53` all traffic on port 53 (UDP)
  - The incoming requests are being forwarded to Google DNS servers 
- The second zone `example.com:53` will receive every query which want to resolve example.com:53
  - After make a lookup in the `example.db` file for the proper record 

## DNS file

The content in that case stored in `example.db`.

There is two main record, what have to configure. SOA and A. 

- SOA "Start of Authority": Thats the initial record used by the DNS server
  - Declare the server authority to the client, which making the query. 

What the first line mean: 

- `example.com` refers the zone in which this DNS server is responsible for
- `SOA` Type of record
- `dns.example.com` Name of the DNS server
- `robbmanes.exampple.com` Name of the admin
- `2015082541` Serial number, must be identical 
- `7200` Refresh rate in seconds. After it client should re-retrive an SOA
- `3600` Retry rate in seconds. After this, any Refresh that faild should be retried.
- `1209600` Time in seconds after the client no longer consider this zone as authoritative. 
- `3600` TTL in seconds, default all records in the zone.

`A` records will store for a domain the IP 
`CNAME` Stand for alias

```
docker run -d --name coredns --restart=always --volume=/home/richard/Desktop/Ericsson/dns-task/docker/:/root/ -p 100:100/udp coredns/coredns -conf /root/Corefile
```

Output of `dig` where the IP is the container IP: 

```
dig @172.17.0.2 -p 100 host.example.com

; <<>> DiG 9.16.1-Ubuntu <<>> @172.17.0.2 -p 100 host.example.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 51909
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 2839521619bb4ded (echoed)
;; QUESTION SECTION:
;host.example.com.		IN	A

;; ANSWER SECTION:
host.example.com.	0	IN	A	192.168.1.3

;; Query time: 0 msec
;; SERVER: 172.17.0.2#100(172.17.0.2)
;; WHEN: p okt 02 13:27:47 CEST 2020
;; MSG SIZE  rcvd: 89

```

## Sources

[Running CoreDNS as a DNS server in a container](https://dev.to/robbmanes/running-coredns-as-a-dns-server-in-a-container-1d0)
