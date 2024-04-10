# distributed databases

![](assets/scale.png)

*distributed database management systems ddbms*

- scaling horizontally on multiple nodes.
- may achieve linear speed-up and scale-up if neither memory nor compute is shared between nodes.
- improved availability, performance, scalability, support for heterogeneous nodes.

*fragmentation*

- break relation into smaller fragments, stored at different sites
- requires completeness, non-redundancy of data
- requires local view: fragments should be identifiable without needing to see the entire dataset
- on allocation, fragments get distributed among nodes:
	- horizontal fragmentation/**sharding**: share subsets of rows
	- vertical fragmentation: share subsets of columns
	- mixed/hybrid fragmentation

*replication*

- replicas enable fault tolerance, load balancing, data locality
- a) primary-secondary replication:
	- primary node (as single source of truth), updates secondaries
	- secondary nodes can still process read-operations, even while primary is dead
- b) (multi-primary) peer-to-peer replication:
	- every peer can process update-requests, so they're all being processed in parallel

*coordination*

- = distributed concurrency control
- usually high overhead
- detecting deadlocks: through consensus protocols like two-phase-commit 2PC, where nodes decide whether to commit or to abort a distributed atomic transaction
- write write conflict: either lock or regularly check for inconsistency
- read write conflict: unrepeatable read. check with other nodes
- inconsistency window: time needed to restore state

*fault tolerance*

- = distributed recovery
- surviving failures of servers, links, messages, network (partition tolerance)
- recognize failures, minimze downtime

*transparency*

- = abstraction over distributed nature of data

*efficiency*

- = improving performance through spacial and temporal locality, load balancing

*consistency*

- strong consistency:
	- single node: transactions have ACID properties
	- cluster: system transparency
	- often traded off for more performance/throughput
- eventual consistency:
	- if no more updates arrive, system will at some point be consistent again
- causal consistency:
	- nodes will agree on operation-order based on their causal relations - ie. a read before a right is considered a potential cause of the write

*ACID*

- A = atomicity → all steps in a single database transaction are either fully-completed or reverted to their original state
- C = consistency → data meets integrity constraints
- I = isolation → lock on access: a new transaction, waits until the previous one finishes, before it starts operation
- D = durability → persistence even on failure

*BASE*

- https://aws.amazon.com/compare/the-difference-between-acid-and-base-database/
- BA = basically available → little downtime
- S = soft state → system doesn't have to be in consistent state all the time
- E = eventually consistent → if no more updates arrive, system will at some point be consistent again

*CAP theorem*

- C = single copy consistency → system behaves as if operations were processed one at a time on a single copy
- A = availability → every request received by a non-failing node in the cluster must result in a response
- P = partition tolerance → the system continues to operate despite dropped or delayed messages between the distributed nodes
- cap theorem = in a cluster, you can have at most 2 of the 3 properties (Seth Gilbert and Nancy Lynch, MIT)
	- C vs. A: network partitions can not be excluded
	- AP > CP: prefer availability over consistency
	- CA: impractical, would mean complete shutdown during a partition

*PACELC theorem*

- PAC → A-C trade-off in case of network partition
- ELC → 'E'lse trade-off between 'L'atency and 'C'onsistency
- this gives us 4 types:
	- PA/EC: where A>C in case of partition and C>L

*quorum consensus*

- read/write quorum: num replicas needed to contact for read/write operation to succeed

*logical clocks*

- lamport clock, scalar clock:
	- we increment a counter on special events
	- no total order: 2 processes can have the same number/time
- vector clock:
	- we keep a vector containing clocks of all nodes

# noSQL

*issues of relational databases*

- schema must be known, data must be structured
- data must be homogenous, can't be nested, can't be a graph
- not suitable for sparse data
- sharding is hard
- fewer integration databases, more application databases (ie. each service has it's own db instance in some docker instance)
- only 6.8% of the execution time is spent on "useful work" (M. Stonebraker et al.). the rest is spent on:
	- buffer management (34.6%): disk io
	- locking (16.3%) and latching (14.2%): concurrency access control
	- logging (11.9%): for durability guarantees
	- other stuff (16.2%)

*non relational databases*

- nosql = not only sql (no standardized query language)
- schema on read = we don't type check but expect a structure based on queries. hard to maintain.
- **weak/no transactions** = guarantees BASE instead of ACID properties. only suitable for non-critical transactional systems that don't need strong consistency.
- **aggregate** = bundle of objects for updates and transmission. they're bundled based on spacial/temporal locality. easier for distributed processing. need denormalization during data modelling.

*key-value store*

- = indexed by key
- data stored in arbitrary data structure, data type is only known to the application. hard to maintain [^mickens]
- doesn't allow complex queries
- no locks: write-write conflicts are rare but may happen. a process scans for conflict.
- bucket (key, value, metadata) = logical entity, namespace for keys
- ie. riak kv, redis, dynamodb/voldemort, berkley db
	- riak is decentralized, written in erlang, has high availability, 3 basic operations (get, put, delete)
	- you can use tags to retrieve multiple objects, traverse by walking links, run full text search, mapreduce

*document store*

- = can understand formats like json, xml
- arbitrary document structure
- allows advanced queries, but not joins (for performance reasons)
- ie. mongodb, couchdb

*column oriented databases*

- = a) columnar database
	- data stored in columns
	- technically not considered nosql
	- arbitrary combination of columns
	- better cache locality than fetching rows, fast vectorized operations (simd)
	- can use virtual ids: memory offset to find data, as long as it's fixed length or compressed
	- compression: makes sense because cpu time is cheaper than io time (run length encoding, bit vector encoding, dictionary encoding, null suppression for sparse data, lempel-ziv, huffman coding) – some operations can be done on compressed data directly
	- late materialization: combine columns as late as possible to avoid having to keep intermediate results in memory
	- ie. monetdb, apache kudu (on hadoop), druid (apache), vertica, sybaseIq
- = b) column family store/wide column store
	- indexing by id and then column name
	- is considered nosql
	- sorted strings table sst: immutable file format to store logs and data files, key/value string pairs sorted by key
	- ie. google file system gfs, hbase, bigtable, cassandra

*graph database*

- = entities and relationships
- aggregate-ignorant (like relational databases)
- fully acid compliant
- most of information is stored in relationships between id's of aggregates, optimized for graph traversal queries
- not suitable for sharding, but 'clusters' inside database can be cached by bringing some of their parts into the ram
- ie. neo4j (network exploration and optimization for java), tigergraph

[^mickens]: https://youtu.be/7Nj9ZjwOdFQ?si=6IQNB6Adw1NuDThX&t=513
