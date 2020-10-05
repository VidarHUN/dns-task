# How to add files to minikube 

`minikube ssh`

Create a folder `/mnt/data/config`. 

`sudo mkdir /mnt/data/config`

Then install an editor:

`sudo apt update && sudo apt install nano`

Create these files in the `config` directory: 

- Corefile
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
- example.db
  ```
  example.com.        IN  SOA dns.example.com. robbmanes.example.com. 2015082541 7200 3600 1209600 3600
  gateway.example.com.    IN  A   192.168.1.1
  dns.example.com.    IN  A   192.168.1.2
  host.example.com.   IN  A   192.168.1.3
  server.example.com. IN  CNAME   host.example.com
  ```
