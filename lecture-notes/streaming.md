## CMSC 498O: Streaming Data/Real-time Analytics

### Motivation

- Much data generated continuously (growing every day)
    - Financial data
    - Sensors, RFID
    - Network/systems monitoring
    - Video/Audio data
    - etc ...

- Need to support:
    - High data rates
    - Real-time processing with low latencies
    - Support for temporal reasoning (time-series operations)
    - Data dissemination
    - Distributed ? (at least data generation)
    - etc...

- Examples of Tasks
- {\bf Continuous} (SQL) queries 
	- E.g. moving average over last hour every 10 mins
	- SQL extended to support ``windows'' over streams
	- Proposed extensions: SEQUENCE, CQL, StreamSQL
- Pattern recognition
	- Alert me when: $A$, then $B$ within 10 mins
	- How to specify ? StreamSQL has some support
- Probabilistic modeling; Applying financial models
	- Infer hidden variables
	- Remove noise (from measured readings)
	- Do complex analysis to decide whether to {\em buy}
	- We don't even know how to specify these
- Multimedia data ?
	- Online object detection, activity detection
	- Correlating events from different streams

- Why can't we use traditional DBMS ?

- Consider simplest case:
	- Report moving average over last hour every 10 minutes
	    - 1. Insert all new items into database
	    - 2. Execute the query every 10 minutes
    - Not easily generalizable to other tasks
    - E.g. ``alert me the moment moving average > 100'' ?
    - Typically 1000's of such continuous queries
    - Even for one query, too slow and inefficient
        - Doesn't reuse work from previous execution
    - Application-level modules typically used for complex tasks

- Related Concepts:
    - Triggers ?
        - Similar, but current trigger systems not designed for the required scale
    - Publish-Subscribe Systems
        - Similar concepts: Push-based, reactive execution
        - Typically no complex queries
        - Much focus on ``dissemination''

- Major research systems focused on data streaming for relational data (late 90's-early 00's):
    - NiagaraCQ (Wisc), Telegraph, TelegraphCQ (Berkeley), STREAM (Stanford), Autora, Borealis, Medusa (Brown/Brandeis/MIT)
    - Commercial: Oracle*Streams, Strembase etc...
    - Many questions explored in depth, but no real unifying theme or consensus emerged
         - Today the support for streams in standard DBMS is still somewhat ad hoc 
         - There are also many specialized vertical tools for specific applications (e.g., finance)


- Streaming and real-time analytics has re-emerged in recent years in the NoSQL world
     - [A detailed motivation/rationale by the Apache Storm Project](https://storm.apache.org/documentation/Rationale.html)
     - Key differentiations analogous to the differentiation between relational databases and MapReduce-style systems
            - Focus on distributed, fault-tolerance execution at scale
            - Eschew any specific data model, but rather allow users to write arbitrary computations easily
     - Some key systems:
            - [Apache Storm](http://storm.apache.org/)
            - [Spark Streaming](https://spark.apache.org/streaming/)
            - [LogStash](http://logstash.net/): focus more on log data analysis
            - Messaging systems: ZeroMQ, RabbitMQ, Kafka, etc.
     - Somewhat fragmented and rapidly evolving space, with many open and exciting questions
