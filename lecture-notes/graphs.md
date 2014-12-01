## CMSC 498O: Graph Data Management

- Goal: Manage graph-structured data, i.e., data containing a set of entities and interconnections between them, and/or execute various types of network analysis queries over them

- See [PDF Slides](graphs.pdf) for an overview of Graph Data Management

- Specific graph analytics techniques discussed in class:
    - [PageRank](http://en.wikipedia.org/wiki/PageRank) -- the above slides also have a detailed description
    - [Betweenness Centrality](http://en.wikipedia.org/wiki/Betweenness_centrality): Only the basic idea, not the algorithms
    - [Community Detection](http://en.wikipedia.org/wiki/Community_structure): Some basic intuitions about it

- Vertex-centric programming framework 
    - Originally used by Google's Pregel System, and now adopted (with some variations) by many other systems including Giraph, GraphLab, etc.
    - The above slides contain a basic overview
    - For more details, see the [original Pregel Paper](http://dl.acm.org/citation.cfm?id=1807184)

- GraphX programming framework
    - GraphX is based on Spark and hence on Map-Reduce
    - The core primitive is mapReduceTriplets, which enables an edge-centric programming framework, which in turn can be used to simulate vertex-centric programming framework
    - See [Lab 9](https://github.com/umddb/datascience-fall14/tree/master/lab9) for more details

- Query Languages for Graph Databases
    - Neo4j Cypher: See Lab 9
    - [Gremlin](https://github.com/tinkerpop/gremlin/wiki): A relatively low-level graph traversal languages
    - [SPARQL](http://en.wikipedia.org/wiki/SPARQL): The query language for RDF data/Semantic Web
