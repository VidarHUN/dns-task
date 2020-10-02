# DNS

The DNS will find out the requested domain IP address. 

### Types of DNS server

- DNS recursor: Designed to receive queries from client machines through applications. The recursor is responsible for making additional requests in order to satisfy the client's DNS query. 
- Root nameserver: Stores key-value pair for Domain Names and their IPs. 
- TLD nameserver: Responsible for the `.com` or `.hu` tag
- Authoritative nameserver: Return the actual IP address for the domain. 

Without any caching the client will request recursively the DNS Resolver. If it is not contain the desired record, then that DNS resolver act like a client to, and ask other DNS servers, like Root Server or TLD server. 

![DNS Lookup](https://www.cloudflare.com/img/learning/dns/what-is-dns/dns-lookup-diagram.png)

### The process 

First the resolver queries the root nameserver. The root server is the first step in translating (resolving) human-readable domain names into IP addresses. The root server then responds to the resolver with the address of a Top Level Domain (TLD) DNS server (such as .com or .net) that stores the information for its domains.

Next the resolver queries the TLD server. The TLD server responds with the IP address of the domain’s authoritative nameserver. The recursor then queries the authoritative nameserver, which will respond with the IP address of the origin server.

The resolver will finally pass the origin server IP address back to the client. Using this IP address, the client can then initiate a query directly to the origin server, and the origin server will respond by sending website data that can be interpreted and displayed by the web browser.

### DNS caching 

If one Domain Name IP resolved that will be saved locally with a TTL (Time To Live) value. So If we request `google.com` once the DNS record saved locally for example with 24 TTL. So the next request no longer goes out to the DNS server because it has the IP address locally. It only goes out again after 24 hours.

### DNS lookup

1. A user types `example.com` into a web browser and the query travels into the Internet and is received by a DNS recursive resolver.
2. The resolver then queries a DNS root nameserver (.).
3. The root server then responds to the resolver with the address of a Top Level Domain (TLD) DNS server (such as .com or .net), which stores the information for its domains. When searching for example.com, our request is pointed toward the .com TLD.
4. The resolver then makes a request to the .com TLD.
5. The TLD server then responds with the IP address of the domain’s nameserver, example.com.
6. Lastly, the recursive resolver sends a query to the domain’s nameserver.
7. The IP address for example.com is then returned to the resolver from the nameserver.
8. The DNS resolver then responds to the web browser with the IP address of the domain requested initially.
9. Once the 8 steps of the DNS lookup have returned the IP address for example.com, the browser is able to make the request for the web page:

10. The browser makes a [HTTP](https://www.cloudflare.com/learning/ddos/glossary/hypertext-transfer-protocol-http/) request to the IP address.
11. The server at that IP returns the webpage to be rendered in the browser (step 10).

### DNS queries

These are usually used combined. 

1. Recursive query: Client request the DNS server (usually the DNS recursive resolver), and the server respond back the record or an error if not found. 
2. Iterative query: If the requested DNS server not have any match it will send to a lower level of the domain space and so on until an error a timeout. 
3. Non-recursive query: If the requested record already in the cache or the DNS serve is Authoritative.

### DNS records 

DNS records (aka zone files) are instructions that live in authoritative [DNS servers](https://www.cloudflare.com/learning/dns/dns-server-types/) and provide information about a domain including what [IP address](https://www.cloudflare.com/learning/dns/glossary/what-is-my-ip-address/) is associated with that domain and how to handle requests for that domain. These records consist of a series of text files written in what is known as DNS syntax. DNS syntax is just a string of characters used as commands that tell the DNS server what to do. All DNS records also have a ‘[TTL](https://www.cloudflare.com/learning/cdn/glossary/time-to-live-ttl/)’, which stands for time-to-live, and indicates how often a DNS server will refresh that record.

- **A record** - The record that holds the IP address of a domain.
- **CNAME record** - Forwards one domain or subdomain to another domain, does NOT provide an IP address.
- **MX record** - Directs mail to an email server.
- **TXT record** - Lets an admin store text notes in the record. 
- **NS record** - Stores the name server for a DNS entry.
- **SOA record** - Stores admin information about a domain.
- **SRV record** - Specifies a port for specific services.
- **PTR record** - Provides a domain name in reverse-lookups.

### DNS server fail protection 

Usually there is a lot of redundancy out there and multiple TLD and Root server. So if one goes down for any reason, the traffic simply goes for an other DNS server. 

# Sources

https://www.cloudflare.com/learning/dns/what-is-a-dns-server/

https://www.cloudflare.com/learning/dns/what-is-dns/

https://www.cloudflare.com/learning/dns/dns-records/

