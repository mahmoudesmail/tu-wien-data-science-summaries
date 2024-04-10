# hadoop

"apache hadoop" is a distributed filesystem based on:

- Ghemawat, Sanjay, Howard Gobioff, and Shun-Tak Leung. "The Google file system." Proceedings of the nineteenth ACM symposium on Operating systems principles. 2003.
- Dean, Jeffrey, and Sanjay Ghemawat. "MapReduce: simplified data processing on large clusters." Communications of the ACM 51.1 (2008): 107-113.

the hadoop landscape is mostly written in jvm languages.

*hdfs*

- https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html
- user space file system: data has to be written back and forth between FS and HDFS
- blocks = default size is 128mb, replicated 3 times
- namenode = master, maintains system tree, file metadata, usually multiple active/standby nodes for higher availability
- datanode = worker, reads/writes data
	- 1 of 3 replicas syncs itself up with the 2 others on each update

*hive*

- hiveQL = sql-like interface for hadoop (reduced instruction set)
- compiles queries to jobs for underlying execution engine (mapreduce, apache tex, spark)
- enables 'schemata' for data, conflicts are detected on read
- hive database = namespace of all tables

*spark*

- in memory cluster computing platform
	- has many components, 'spark core' is the scheduler and manager
	- faster alternative to mapreduce
	- written in scala, lazy eval
	- let's you customize number of partitions/replicas based on key/value pairs of RDDs
	- can run on hadoop and access any of the hadoop data sources: HDFS, amazon s3, hive, hbase, etc.
- **node types**:
	- driver program = master, launches parallel programs on cluster, contains the 'sparkcontext', manages DAG of data-dependencies between jobs assigned to worker nodes
		- narrow dependency: each parent partition has ≤1 children. no interdependence between partitions.
		- wide dependency: arbitrary many data-dependent dependencies between parent and child partitions. requires shuffling (repartitioning, redistributing) data across nodes.
	- worker node = contains executor that runs tasks/jobs. each executor is an independent jvm
- **data types**:
	- resilient distributed dataset rdd = immutable collection of objects, default datastructure in spark, supports unstructured data
	- dataframes = has a schema. elements are of type row (you can't type check for columns), can be created from rdd. allows you to use spark-sql api
	- dataset = strongly typed jvm classes with compile time safety
