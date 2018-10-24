# Elasticsearch


> **Elasticsearch** is a highly scalable open-source full-text search and analytics engine. It allows you to store, search, and analyze big volumes of data quickly and in near real time.

> A **Cluster** is a collection of one or more nodes (servers) that together holds your entire data and provides federated indexing and search capabilities across all nodes.

> A **Node** is a single server that is part of your cluster, stores your data, and participates in the cluster’s indexing and search capabilities.

> An **Index** is a collection of documents that have somewhat similar characteristics. 

> A **Type** is a logical partition of index

> A **Document** is a basic unit of information that can be indexed.

> An index can potentially store a large amount of data that can exceed the hardware limits of a single node.To solve this problem, Elasticsearch provides the ability to subdivide your index into multiple pieces called **Shards**. 
**Sharding is important for two primary reasons**
It allows you to horizontally split/scale your content volume
It allows you to distribute and parallelize operations across shards (potentially on multiple nodes) thus increasing performance/throughput

> Elasticsearch allows you to make one or more copies of your index’s shards called **Replica**. 
**Replication is important for two primary reasons:
- It provides high availability in case a shard/node fails.
- It allows you to scale out your search volume/throughput since searches can be executed on all replicas in parallel.

> Installation guide  https://www.elastic.co/guide/en/elasticsearch/reference/current/_installation.html

##Index Operation (CRUD- Create, Read, Update, Delete)
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
