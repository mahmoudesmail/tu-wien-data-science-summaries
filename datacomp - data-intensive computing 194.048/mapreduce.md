*hadoop*

- NameNode: stores all metadata and block locations in memory
- DataNodes: stores and fetches blocks for client or nameNode
- jobs (jar files) without YARN (yet another resource negotiator):
    - master node: JobTracker
    - worker node: TaskTracker, storage of intermediate data

*mapreduce pattern*

```python
def map(docid a, doc d):
    for word in d:
        emit_intermediate(word, 1)

def combine(word w, list<count> counts):
    # do more local processing before passing to reduce
    ...

def reduce(word w, list<count> counts):
    int result = 0
    for v in counts:
        result += v
    emit(w, result)
```

- map:
     - `[(k, v)] -> [(k', v')]`
     - process one key-value pair at a time, return a list of key-value pairs
     - ingest data
- shuffle & sort:
     - `[(k, v)] -> [(k', [v'])]`
     - group and sort the key-value pairs by key
- reduce:
     - `[(k, [v])] -> [(k', v')]`
     - process one key and its list of values at a time, return a list of key-value pairs
