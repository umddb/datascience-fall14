---

# CMSC 498O: NoSQL Stores

---

## Overview

- Geared toward the second use case 
    - Large-scale web application that need real-time access
        - With a few ms latencies (e.g., Facebook == 4ms for reads)

- Problems with using databases
    - Too slow 
    - Don't need ACID properties, or at least full-blown transactions
    - Too expensive (monetary cost)

- Interesting numbers from a few years ago (\myhref{http://highscalability.com}{http://highscalability.com})
    - Twitter: 177M tweets sent on 3/1/2011 (nothing special about the date), 572,000 accounts added on 3/12/2011
    - Dropbox: 1M files saved every 15 mins
    - Stackoverflow: 3M page views a day (Redis for caching)
    - Wordnik: 10 million API Requests a Day on MongoDB and Scala
    - Mollom: Killing Over 373 Million Spams at 100 Requests Per Second (Cassandra)
    - Facebook's New Real-time Messaging System: HBase to Store 135+ Billion Messages a Month
        - Interestingly: decided to move away from Cassandra because not happy with the eventual consistency model
    - Reddit: 270 Million Page Views a Month in May 2010 (Memcache)

- Key challenge 1: Guaranteeing consistency in a distributed environment
    - Need replication for availability, performance, and fault-tolerance

    - How to update them simultaneously?
        - **2-Phase Commit**: Original proposal for doing this
             - Can't handle *master* failure
        - **Paxos**: More widely used today -- doesn't require a master so more fault tolerant

    - Either of them is too expensive in general

    - Many systems use *relaxed/loose* consistency models
        - **Eventual consistency** was popularized by Amazon DynamoDB
            - Guarantees provided only on the eventual outcome
            - Cannot provide guarantees about what different clients will see, in which order they will see updates etc.
        - **Quorums**
            - Let *N* be the total number of replicas
            - When writing, we make sure to write to *W* replicas
            - When reading, we read from *R* replicas and pick the latest (using timestamps, or *vector clocks*)
            - If *W + R > N* and *W + W > N*, we have a fully consistent system
                - So the system wouldn't be available if there is a network partition
            - For other values of *W* and *R*, we end up with looser guarantees
            
    - CAP theorem: can have two of: consistency, availability, and tolerance to network partitions
        - Originally a conjecture (Eric Brewer), but made formal later (Gilbert, Lynch, 2002)
        - Theorem: *It is impossible in the asynchronous network model to implement a read/write data object that guarantees the following properties:*
            - *Availability*
            - *Atomic consistency in all fair executions (including those in which messages are lost).*
        - In other words, if there is a network partition, we can:
            - Go down (sacrifice availability), or
            - Allow inconsistency

- Key Challenge 2: Performance and Scale
     - Must give up something if you want to really scale
        - Give up Consistency (as discussed above)
        - Give up Joins
            - Most NoSQL stores don't allow joins
            - Instead require data to be denormalized and duplicated
        - Only allow very restricted transactions
            - Most NoSQL stores will only allow one object transactions (e.g., one document, or one key)

- Denormalization
    - See [MongoDB notes](http://docs.mongodb.org/manual/core/data-modeling-introduction/) on this topic
    - Denormalization can be used to avoid joins, but usually at the cost of duplication, which opens up the potential for anomalies when the duplicated information is not
    kept in sync

- Some of the key differntiators
    - Data Model: Key-value, Wide-column, Document (JSON), Property Graph
    - Underlying architecture (e.g., Cassandra uses a P2P-style architecture underneath)
    - Replication scheme
    - Querying functionality
        - Cassandra has minimal query language, whereas MongoDB query language is much more function and support aggregations and map-reduce
    - CAP
        - Cassandra supports tunable consistency
        - HBase gives up availability
        - See [this post](http://blog.nahurst.com/visual-guide-to-nosql-systems) for other systems and a longer discussion
