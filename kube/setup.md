# Kubernetes setup

Follow the minikube setup and deploy the `dns.yaml` file. 

![kubernets_arch](C:\Users\Richard\Desktop\Ericsson\dns-task\kube\kube-arch.svg)

After that you can test the DNS service: 

```
dig @172.17.0.3 -p 31000 host.example.com  

; <<>> DiG 9.16.1-Ubuntu <<>> @172.17.0.3 -p 31000 host.example.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 19669
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: d97edfadde01095f (echoed)
;; QUESTION SECTION:
;host.example.com.		IN	A

;; ANSWER SECTION:
host.example.com.	0	IN	A	192.168.1.3

;; Query time: 0 msec
;; SERVER: 172.17.0.3#31000(172.17.0.3)
;; WHEN: h okt 05 10:26:35 CEST 2020
;; MSG SIZE  rcvd: 89
```

