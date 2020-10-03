# Elasticsearch


> **Elasticsearch** is a highly scalable open-source full-text search and analytics engine. It allows you to store, search, and analyze big volumes of data quickly and in near real time.

> A **Cluster** is a collection of one or more nodes (servers) that together holds your entire data and provides federated indexing and search capabilities across all nodes.

> A **Node** is a single server that is part of your cluster, stores your data, and participates in the cluster’s indexing and search capabilities.

> An **Index** is a collection of documents that have somewhat similar characteristics. 

> A **Type** is a logical partition of index

> A **Document** is a basic unit of information that can be indexed.

> An index can potentially store a large amount of data that can exceed the hardware limits of a single node.To solve this problem, Elasticsearch provides the ability to subdivide your index into multiple pieces called **Shards**. 

**Sharding is important for two primary reasons**
- It allows you to horizontally split/scale your content volume
- It allows you to distribute and parallelize operations across shards (potentially on multiple nodes) thus increasing performance/throughput

> Elasticsearch allows you to make one or more copies of your index’s shards called **Replica**. 

**Replication is important for two primary reasons:**
- It provides high availability in case a shard/node fails.
- It allows you to scale out your search volume/throughput since searches can be executed on all replicas in parallel.

> Installation guide  https://www.elastic.co/guide/en/elasticsearch/reference/current/_installation.html

## Elasticsearch Provisioning and bootstraping through Terraform:
- Provision instance using Terraform:
Installation and configuration can be done through Bash Script <install_es.sh>
terrform plan - To get the provisioning details
terraform apply - To create the infrastructure

> Following cnfiguration done through automation (edit /etc/elasticsearch/elasticsearch.yml file)

```sh
network.host: 0.0.0.0
discovery.type: single-node
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true 
xpack.security.transport.ssl.verification_mode: certificate 
xpack.security.transport.ssl.keystore.path: elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: elastic-certificates.p12
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.keystore.path: http.p12
```
- Login to VM using ssh with private key 
For example: ssh -i keyname ubuntu@<ip-address>
        

- Encrypted communication & Password for Elasticsearch:

```sh
$/usr/share/elasticsearch/bin/elasticsearch-certutil  ca
This tool assists you in the generation of X.509 certificates and certificate
signing requests for use with SSL/TLS in the Elastic stack.

The 'ca' mode generates a new 'certificate authority'
This will create a new X.509 certificate and private key that can be used
to sign certificate when running in 'cert' mode.

Use the 'ca-dn' option if you wish to configure the 'distinguished name'
of the certificate authority

By default the 'ca' mode produces a single PKCS#12 output file which holds:
    * The CA certificate
    * The CA's private key

If you elect to generate PEM format certificates (the -pem option), then the output will
be a zip file containing individual files for the CA certificate and private key

Please enter the desired output file [elastic-stack-ca.p12]: 
Enter password for elastic-stack-ca.p12 : 

$/usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12

This tool assists you in the generation of X.509 certificates and certificate
signing requests for use with SSL/TLS in the Elastic stack.

The 'cert' mode generates X.509 certificate and private keys.
    * By default, this generates a single certificate and key for use
       on a single instance.
    * The '-multiple' option will prompt you to enter details for multiple
       instances and will generate a certificate and key for each one
    * The '-in' option allows for the certificate generation to be automated by describing
       the details of each instance in a YAML file

    * An instance is any piece of the Elastic Stack that requires an SSL certificate.
      Depending on your configuration, Elasticsearch, Logstash, Kibana, and Beats
      may all require a certificate and private key.
    * The minimum required value for each instance is a name. This can simply be the
      hostname, which will be used as the Common Name of the certificate. A full
      distinguished name may also be used.
    * A filename value may be required for each instance. This is necessary when the
      name would result in an invalid file or directory name. The name provided here
      is used as the directory name (within the zip) and the prefix for the key and
      certificate files. The filename is required if you are prompted and the name
      is not displayed in the prompt.
    * IP addresses and DNS names are optional. Multiple values can be specified as a
      comma separated string. If no IP addresses or DNS names are provided, you may
      disable hostname verification in your SSL configuration.

    * All certificates generated by this tool will be signed by a certificate authority (CA).
    * The tool can automatically generate a new CA for you, or you can provide your own with the
         -ca or -ca-cert command line options.

By default the 'cert' mode produces a single PKCS#12 output file which holds:
    * The instance certificate
    * The private key for the instance certificate
    * The CA certificate

If you specify any of the following options:
    * -pem (PEM formatted output)
    * -keep-ca-key (retain generated CA key)
    * -multiple (generate multiple certificates)
    * -in (generate certificates from an input file)
then the output will be be a zip file containing individual certificate/key files

Enter password for CA (elastic-stack-ca.p12) : 
Please enter the desired output file [elastic-certificates.p12]: 
Enter password for elastic-certificates.p12 : 

Certificates written to /usr/share/elasticsearch/elastic-certificates.p12

This file should be properly secured as it contains the private key for 
your instance.

This file is a self contained file and can be copied and used 'as is'
For each Elastic product that you wish to configure, you should copy
this '.p12' file to the relevant configuration directory
and then follow the SSL configuration instructions in the product guide.

For client applications, you may only need to copy the CA certificate and
configure the client to trust this certificate.

cp /usr/share/elasticsearch/elastic-certificates.p12 /etc/elasticsearch/
chown root.elasticsearch /etc/elasticsearch/elastic-certificates.p12
chmod 660 /etc/elasticsearch/elastic-certificates.p12

/usr/share/elasticsearch/bin/elasticsearch-certutil  http

## Elasticsearch HTTP Certificate Utility

The 'http' command guides you through the process of generating certificates
for use on the HTTP (Rest) interface for Elasticsearch.

This tool will ask you a number of questions in order to generate the right
set of files for your needs.

## Do you wish to generate a Certificate Signing Request (CSR)?

A CSR is used when you want your certificate to be created by an existing
Certificate Authority (CA) that you do not control (that is, you don't have
access to the keys for that CA). 

If you are in a corporate environment with a central security team, then you
may have an existing Corporate CA that can generate your certificate for you.
Infrastructure within your organisation may already be configured to trust this
CA, so it may be easier for clients to connect to Elasticsearch if you use a
CSR and send that request to the team that controls your CA.

If you choose not to generate a CSR, this tool will generate a new certificate
for you. That certificate will be signed by a CA under your control. This is a
quick and easy way to secure your cluster with TLS, but you will need to
configure all your clients to trust that custom CA.

Generate a CSR? [y/N]N

## Do you have an existing Certificate Authority (CA) key-pair that you wish to use to sign your certificate?

If you have an existing CA certificate and key, then you can use that CA to
sign your new http certificate. This allows you to use the same CA across
multiple Elasticsearch clusters which can make it easier to configure clients,
and may be easier for you to manage.

If you do not have an existing CA, one will be generated for you.

Use an existing CA? [y/N]N
A new Certificate Authority will be generated for you

## CA Generation Options

The generated certificate authority will have the following configuration values.
These values have been selected based on secure defaults.
You should not need to change these values unless you have specific requirements.

Subject DN: CN=Elasticsearch HTTP CA
Validity: 5y
Key Size: 2048

Do you wish to change any of these options? [y/N]N

## CA password

We recommend that you protect your CA private key with a strong password.
If your key does not have a password (or the password can be easily guessed)
then anyone who gets a copy of the key file will be able to generate new certificates
and impersonate your Elasticsearch cluster.

IT IS IMPORTANT THAT YOU REMEMBER THIS PASSWORD AND KEEP IT SECURE

CA password:  [<ENTER> for none]

## How long should your certificates be valid?

Every certificate has an expiry date. When the expiry date is reached clients
will stop trusting your certificate and TLS connections will fail.

Best practice suggests that you should either:
(a) set this to a short duration (90 - 120 days) and have automatic processes
to generate a new certificate before the old one expires, or
(b) set it to a longer duration (3 - 5 years) and then perform a manual update
a few months before it expires.

You may enter the validity period in years (e.g. 3Y), months (e.g. 18M), or days (e.g. 90D)

For how long should your certificate be valid? [5y] 3Y

## Do you wish to generate one certificate per node?

If you have multiple nodes in your cluster, then you may choose to generate a
separate certificate for each of these nodes. Each certificate will have its
own private key, and will be issued for a specific hostname or IP address.

Alternatively, you may wish to generate a single certificate that is valid
across all the hostnames or addresses in your cluster.

If all of your nodes will be accessed through a single domain
(e.g. node01.es.example.com, node02.es.example.com, etc) then you may find it
simpler to generate one certificate with a wildcard hostname (*.es.example.com)
and use that across all of your nodes.

However, if you do not have a common domain name, and you expect to add
additional nodes to your cluster in the future, then you should generate a
certificate per node so that you can more easily generate new certificates when
you provision new nodes.

Generate a certificate per node? [y/N]N

## Which hostnames will be used to connect to your nodes?

These hostnames will be added as "DNS" names in the "Subject Alternative Name"
(SAN) field in your certificate.

You should list every hostname and variant that people will use to connect to
your cluster over http.
Do not list IP addresses here, you will be asked to enter them later.

If you wish to use a wildcard certificate (for example *.es.example.com) you
can enter that here.

Enter all the hostnames that you need, one per line.
When you are done, press <ENTER> once more to move on to the next step.

13.234.67.113

You entered the following hostnames.

 - 13.234.67.113

Is this correct [Y/n]Y

## Which IP addresses will be used to connect to your nodes?

If your clients will ever connect to your nodes by numeric IP address, then you
can list these as valid IP "Subject Alternative Name" (SAN) fields in your
certificate.

If you do not have fixed IP addresses, or not wish to support direct IP access
to your cluster then you can just press <ENTER> to skip this step.

Enter all the IP addresses that you need, one per line.
When you are done, press <ENTER> once more to move on to the next step.

13.234.67.113

You entered the following IP addresses.

 - 13.234.67.113

Is this correct [Y/n]Y

## Other certificate options

The generated certificate will have the following additional configuration
values. These values have been selected based on a combination of the
information you have provided above and secure defaults. You should not need to
change these values unless you have specific requirements.

Key Name: 13.234.67.113
Subject DN: CN=13, DC=234, DC=67, DC=113
Key Size: 2048

Do you wish to change any of these options? [y/N]N

## What password do you want for your private key(s)?

Your private key(s) will be stored in a PKCS#12 keystore file named "http.p12".
This type of keystore is always password protected, but it is possible to use a
blank password.

If you wish to use a blank password, simply press <enter> at the prompt below.
Provide a password for the "http.p12" file:  [<ENTER> for none]

## Where should we save the generated files?

A number of files will be generated including your private key(s),
public certificate(s), and sample configuration options for Elastic Stack products.

These files will be included in a single zip archive.

What filename should be used for the output zip file? [/usr/share/elasticsearch/elasticsearch-ssl-http.zip] 

Zip file written to /usr/share/elasticsearch/elasticsearch-ssl-http.zip

cd /usr/share/elasticsearch
unzip elasticsearch-ssl-http.zip
cp  /usr/share/elasticsearch/elasticsearch/http.p12 /etc/elasticsearch/
chown root.elasticsearch /etc/elasticsearch/http.p12
chmod 660 /etc/elasticsearch/http.p12
```
- Password for elasticsearch:

```sh
/usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto -u https://13.234.67.113:9200
```

## Index Operation (CRUD- Create, Read, Update, Delete)
> List all index:

```sh
GET http://elasticsearch:port/_cat/indices?v
```
> Create an Index:

```sh
PUT http://elasticsearch:port/indexname
{
        "settings": {
                "index": {
                        "number_of_shards": 3,
                        "number_of_replicas": 2
                }
        },

        "mappings": {
                "health": {
                        "properties": {
                                "timestamp": {
                                        "type": "date",
                                        "format": "epoch_millis||epoch_second"
                                }
                        }
                }
        }

}
```
> Delete an index:

```sh
DELETE http://elasticsearch:port/indexname
```

> Add/push data into an index:

```sh
POST http://elasticsearch:port/indexname/_doc/$today
```
> Loading sample dataset:


accounts.json
```sh
{
    "account_number": 0,
    "balance": 16623,
    "firstname": "Bradshaw",
    "lastname": "Mckenzie",
    "age": 29,
    "gender": "F",
    "address": "244 Columbus Place",
    "employer": "Euron",
    "email": "bradshawmckenzie@euron.com",
    "city": "Hobucken",
    "state": "CO"
}

curl -H "Content-Type: application/json" -XPOST "localhost:9200/bank/_doc/_bulk?pretty&refresh" --data-binary "@accounts.json"
curl "localhost:9200/_cat/indices?v"
```

> Used timestamp in script (It will help you to post and retrive data easily on the baisis of timestamp)

```sh
        timestamp=$((`date +%s`*1000+`date +%-N`/1000000))
        today=`date '+%Y%m%d%H%M%S'`
```
> Post and validate the dataset:

```sh
- To post dataset

curl -X POST http://$elasticsearch:$port/indexname/health/$today -d @accounts.json --header "Content-Type: application/json" >> $CWD/$today.log

- To validate imported dataset 

echo "http://$elasticsearch:$port/indexname/health/$today"
```
