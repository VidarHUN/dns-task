# How DNS works in l7mp 

There is an other CoreDNS service, with a different configuration with name of 'test-dns'
which connects to the same Headless service. So in that thats could be reachable by name. 

To use this configuration you have to make a new `PV` and `PVC`.

1. Create a folder: `/mnt/data/test-config` and put these files into it: 
    - `Corefile`
    ```
    .:100 {
        forward . 8.8.8.8 9.9.9.9
        log
        errors
    }

    example.com:100 {
        file /root/example.db
        log
        errors
    }
    ```
    - `example.db`
    ```
    example.com.        IN  SOA dns.example.com. robbmanes.example.com. 2015082541 7200 3600 1209600 3600
    gateway.example.com.    IN  A   192.168.1.1
    dns.example.com.    IN  A   192.168.1.2
    test.example.com.   IN  A   192.168.1.3
    test.server.example.com. IN  CNAME   test.example.com
    ```
2. Create the `PV` and `PVC`: 
    ```yaml
    apiVersion: v1
    kind: PersistentVolume
    metadata:
        name: test-config-pv
        labels: 
            type: local
    spec:
        storageClassName: manual
        capacity:
            storage: 10Gi
        accessModes:
            - ReadWriteOnce
        hostPath:
            path: "/mnt/data/test-config"
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
        name: test-config-pvc
    spec:
        storageClassName: manual
        accessModes:
            - ReadWriteOnce
        resources:
            requests:
            storage: 2Gi
    ```
3. Create a `Statefulset` for these servers:
    ``` yaml
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
    name: test-dns
    labels:
        app: dns
    spec:
    serviceName: dns
    replicas: 2
    selector:
        matchLabels:
        app: dns
    template:
        metadata:
        labels:
            app: dns
        spec:
        containers:
        - name: dns
            image: coredns/coredns
            args: ["-conf", "/root/Corefile"]
            volumeMounts:
                - name: dns-config
                mountPath: "/root"
        volumes:
            - name: dns-config
            persistentVolumeClaim:
                claimName: test-config-pvc
    ```
4. Until this feature is released a local image file should be used, so in the l7mp configuration this should be modified.
5. Configure the l7mp like that way: 
    ``` yaml
    admin:
      log_level: info
      log_file: stdout
      access_log_path: /tmp/admin_access.log
    listeners:
      - name: dns-listener
        spec: 
          protocol: DNS 
          transport: 
            protocol: UDP
            port: 5000
        rules:
          - name: rule-0
            match: { op: matches, path: /DNS/question/name, value: test* }
            action:
              route:
                destination: test-dns
                retry:
                  retry_on: always
                  num_retries: 3
                  timeout: 2000
          - name: rule-1
            match: { op: starts, path: /IP/src_addr, value: 172.17.0.1 }
            action:
              route:
                destination: coredns
                retry: 
                  retry_on: always
                  num_retries: 3
                  timeout: 2000
      - name: controller-listener
        spec: { protocol: HTTP, port: 1234 }
        rules:
          - action:
              route:
                destination:
                  name: l7mp-controller
                  spec: { protocol: L7mpController }
    clusters:
      - name: coredns
        spec: { protocol: UDP, port: 100 }
        endpoints:
          - name: ep0
            spec: { address: dns-0.dns, port: 100 }
          - name: ep1
            spec: { address: dns-1.dns, port: 100 }
      - name: test-dns
        spec: { protocol: DNS, transport: { protocol: UDP, port: 100 }}
        endpoints: 
          - name: ep2
            spec: { address: test-dns-0.dns, port: 100 }
          - name: ep3
            spec: { address: test-dns-1.dns, port: 100 }
    ```

After this configuration you should be able to resolve `test.exapmle.com` too. 