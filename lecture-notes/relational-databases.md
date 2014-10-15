---

# CMSC 498O: Implementation of Relational Database Systems

---

## Overview 

- We will cover the basic components of relational database systems, and how a query is executed

- Specific topics covered:
    - Client-server architecture of a typical database system
    - Key components of a database system 
    - Following an SQL query through the system
        - Parsing + Authentication
        - Rewrite
        - Query optimization
        - Query execution
    - Disk storage
        - Cost differential between random I/Os and sequential I/O
        - B+-tree Indexes
        - Primary vs Secondary Indexes
    - Transactions
        - ACID properties
        - A brief overview of how those are guaranteed

- Detailed notes **will not** be posted for these classes
    - My notes for CMSC424: 
        - [Storage and Indexing](http://www.cs.umd.edu/class/fall2012/cmsc424/lecture-storage.pdf)
        - [Query Execution](http://www.cs.umd.edu/class/fall2012/cmsc424/lecture-queryprocessing.pdf)
        - [Transactions](http://www.cs.umd.edu/class/fall2012/cmsc424/lecture-acid.pdf)
    - Here is an attempt at collating the above three PDFs, and removing stuff that we didn't discuss in the class
        - [Relevant CMSC424 Notes](rdbms-impl.pdf)
    - [Architecture of Database System](http://www.cs.umd.edu/class/spring2008/cmsc724/fntdb07-architecture-merged.pdf): is a great in-depth, but somewhat advanced, overview of how relational databases are built
