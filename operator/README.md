# With l7mp-operator 

## Before you begin

First of all you have to setup a Minikube with **l7mp-ingress and operator**, so 
follow this [Link](Link-to-minikube-setup) guide to achieve it.

If everything up and running you are now able to start this demo. 

## Setup

Like before you have to create the DNS service, which will resolve a simple *A*
record. But in that case you don't have to deal with **StatefulSets** and 
**Headless Service**. The operator will handle this.

This kind of deployment will create a same as before in functionality. 

So just create a simple Deployment with 2 instances of the **DNS server**. Like
that: 

```
kubectl apply -f https://l7mp.io/tasks/dns-task/dns-deployment.yaml
```

So you now only have to expose it out from your cluster, but you will not create
a common Kubernetes service by hand. You will create a **Target** and two 
**VirtualService** object. 

### Target

As you know, with a Target CRD you can create a "cluster" which will have some kind 
of protocol and a set of endpoints. In this case you have to create a cluster inside 
the l7mp-ingress object and stick the pods to it dynamical.

``` yaml
cat <<EOF | kubectl apply -f -
apiVersion: l7mp.io/v1
kind: Target
metadata:
  name: dns-cluster
spec: 
  selector:
    matchExpressions:
      - key: app
        operator: In
        values:
        - l7mp-ingress
  cluster:
    spec:
      UDP:
        port: 5000
    endpoints:
      - selector:
          matchLabels:
            app: dns
EOF
```

The **dns-cluster** listen UDP on port 5000 and send the traffic to every pod 
which has `app: dns` label.

### VirtualServices

With virtual services, you can create listeners who will forward traffic that 
meets the specification to the appropriate endpoints, which in this case are clusters.

First create a listener inside of the pods sidecar. This listener will listen on 
UDP traffic on port 5000 and transfer them to `localhost` on port 100. The 
CoreDNS will listen on that address. 

``` yaml
apiVersion: l7mp.io/v1
kind: VirtualService
metadata:
  name: dns-listener
spec:
  selector:
    matchLabels:
      app: dns
  listener:
    spec:
      UDP:
        port: 5000
    rules:
      - action:
          route:
            destination:
              spec:
                UDP:
                  port: 100
              endpoints:
                - spec: { address: 127.0.0.1 }
            retry:
              retry_on: always
              num_retries: 3
              timeout: 2000
```

After all of this you only have to create the connection with l7mp-ingress and dns pods. 
For this you have to create an other listener which will placed inside of l7mp-ingress 
and forward every traffic from outside of the cluster into dns-cluster which will 
have the pods as endpoints.

``` yaml
apiVersion: l7mp.io/v1
kind: VirtualService
metadata:
  name: gateway
spec:
  selector:
    matchLabels:
      app: l7mp-ingress
  listener:
    spec:
      UDP:
        port: 5000
    rules: 
      - action:
          route:
            destinationRef: /apis/l7mp.io/v1/namespaces/default/targets/dns-cluster
            retry:
              retry_on: always
              num_retries: 3
              timeout: 2000
```

And that's it your own DNS server with l7mp service-mesh are ready to use. You 
will access it on `$(minikube ip):5000`. But if you want to change 
the port number you only have to modify the listener port.

## Test

For testing purpose we recommend using `dig`, but if you want choose another one 
you surely can.

First make one request and see if it's working. The command: 

```
dig @$(minikube ip) -p 5000 host.example.com
```

And you have to see something like that: 

```
; <<>> DiG 9.16.1-Ubuntu <<>> @172.17.0.2 -p 5000 host.example.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47748
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 9122076d2f09d198 (echoed)
;; QUESTION SECTION:
;host.example.com.		IN	A

;; ANSWER SECTION:
host.example.com.	0	IN	A	192.168.1.3

;; Query time: 8 msec
;; SERVER: 172.17.0.2#5000(172.17.0.2)
;; WHEN: k nov 17 09:48:14 CET 2020
;; MSG SIZE  rcvd: 89
```

If the test above are successful you have to run it continuously with the 
`watch` command and open an other terminal. 

In the new terminal try to delete one of the dns pods, and see if the 
`dig` command are crash or something. If it is not crash, everything is 
good.

## Cleanup

```
curl -LO https://l7mp.io/tasks/dsn-task/delete.sh
chmod u+x delete.sh
./delete.sh
```