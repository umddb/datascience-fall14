## CMSC 498O: Distributed Programming Frameworks

- Types of Parallelism
    - Shared memory
        - Direct mapping from uni-processor
        - Data structures shared between processors
            - Process models extend naturally: processes or threads assigned to different processes
            - Cache-coherency can be issues: typically left to the hardware
        - Resurgence as *multi-core*
            - Separate caches, but usually not large enough to call shared-nothing
    - Shared disk
        - Increasingly common because of SAN (storage area network)
        - Better failure behavior (since data still available)
        - Distributed lock managers, cache-coherency etc...
    - Shared nothing
        - Perhaps most common and most scalable
        - Horizontal data partitioning
            - Good partitioning schemes essential
            - More burden on the DBA
         - Query processing and optimization challenging

- Key Concepts:
    - Most database operations are *embarrassingly parallel* (some prefer to call it *infinitely parallel*)
        - **select** and **project**: can be executed on each tuple independently on a separate machine
        - **sort**: Data partitions can be sorted independently and then merged together
        - **group by aggregates**: Partial aggregates can be computed for each machine separately, and then combined together
        - **joins**: Hash joins are naturally parallelizable

    - Speedup vs Scaleup
        - Speedup: old time/new time
        - Scaleup: how many more queries/how much larger query can you solve

    - Types of parallelism:
        - Pipelined 
            - Each ``operator'' on a different processor
            - Easier to setup, but low parallelism
        - Partitioned 
            - Split relations horizontally, replicate the operators
            - Exploits all processors, but much harder to setup 
            - Optimization messy: Need to make decisions about how to split etc..

    - Storage: Round-robin vs Hash-based vs Range-based

    - Barriers to linear speedups
        - Startup overheads
        - Interference
        - Communication overhead, waiting on queues etc..
            - If the interference just 1\%, the maximum speedup < 37
        - Skew
            - Partitioning may turn out to be non-uniform (common cause: duplicates)

- Parallel databases are very successful
    - Primarily targetting data warehousing applications 
    - Teradata, Vertica, Aster, and many others
    - Provide performance and ACID guarantees needed by many applications

- Why parallel databases were not enough for "big data"?
    - The big data movement really started with Google's Map-Reduce proposal, proposed as a replacement for databases
        - In fact, the basic MR model is a simple special case of group by aggregates with user-defined functions
    - Parallel database implementations were not intended for very large clusters of commodity machines
        - Fault-tolerance is a major issue there and existing parallel databases didn't have a good answer
    - Parallel databases were also very expensive
        - Much of the functionality wasn't needed for the applications like indexing etc.
        - The simple MR pattern was much easier to reimplement
    - Parallel databases also suffered with *slow loading*
        - Databases are generally intended for repeated uses
        - Many of the batch analytics tasks are one-off -- the cost of loading those into database quite high
