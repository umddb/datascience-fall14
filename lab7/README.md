# Lab 7

Lab 7 focuses on Key Value Stores used as scalable distributed data storage and processing platforms, and has two parts: (1) Cassandra, and (2) MongoDB.

---

## Part 1: Cassandra

[Cassandra](http://cassandra.apache.org/) is an open-source distributed database management system which is designed to scale to handle large volumes of data processed across a large number of commodity machines. Cassandra's data model is essentially a Key-Value Store wherein data is stored as a partitioned row store with tunable consistency. Each key in Cassandra corresponds to a value which is an object. Each key has values as columns, and columns are grouped together into sets called column families. 

##### Data Model
Rows are organized into tables where the first component of a table's primary key is the partition key. Within a partition, rows are clustered by the remaining columns of the key. Other columns may be indexed separately from the primary key. 
More information about the features, data model, and support for clustering can be found here: [Info](http://en.wikipedia.org/wiki/Apache_Cassandra)

##### Cassadra Query Language
The current major version of the Cassandra Query Language is CQL version 3. The CQL3 documentation for the current version of Cassandra (2.0) is available [here](http://cassandra.apache.org/doc/cql3/CQL.html).

### Installing Cassandra

For this lab we will using a binary tar-ball provided by Apache. The Cassandra release includes the core server, the
[nodetool](http://wiki.apache.org/cassandra/NodeTool) administration command-line interface, and a development shell (`cqlsh` and `cassandra-cli`). 

Use the following simple instructions to install Cassandra. 

- Start by pulling the latest version of the git repository, which contains a `lab7` folder.
- The `lab7` folder has a script called `setup.sh`.
- Open a terminal in the Linux VM and `cd` into the `lab7` folder.
- Type: 
	- chmod 755 setup.sh
	- ./setup.sh
- Check whether CASSANDRA_HOME has been set (`echo $CASSANDRA_HOME`)
    - If not, try `source ~/.profile`
  
		
---

#### Starting Cassandra

- open a terminal and type: `cassandra -f`.  This should start the cassandra service in the foreground and log to the console. 
- If you do not see any exceptions then Cassandra should be up and running.
- More information on the details of setting up and starting Cassandra can be found here: [Quick Start Guide](http://wiki.apache.org/cassandra/GettingStarted) 

#### Using Cassandra using cqlsh
*cqlsh* is an interactive command line interface for Cassandra. *cqlsh* allows you to execute CQL (Cassandra Query Language) statements against Cassandra. Using CQL, you can define a schema, insert data, execute queries.

- open a terminal and type `cqlsh`. You should see the following if successful:

		Connected to Test Cluster at 127.0.0.1:9042.
		[cqlsh 5.0.1 | Cassandra 2.1.1 | CQL spec 3.2.0 | Native protocol v3]
		Use HELP for help.	
- To create and query a table in Cassandra using cqlsh use the following steps: 
- Step 1: Create a key space -- a namespace of tables. At the cqlsh prompt type:

		CREATE KEYSPACE mykeyspace
		WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' :1 }; 

- Step 2: Authenticate to the new keyspace. At the cqlsh prompt type: 

		USE mykeyspace;
		
- Step 3: Create a users table. At the cqlsh prompt type:

		CREATE TABLE users (
  		user_id int PRIMARY KEY,
  		fname text,
  		lname text
		);
		  
- Step 4: Storing data into users. At the cqlsh prompt type:

		INSERT INTO users (user_id,  fname, lname)
  		   VALUES (1745, 'john', 'smith');
		INSERT INTO users (user_id,  fname, lname)
  		   VALUES (1744, 'john', 'doe');
		INSERT INTO users (user_id,  fname, lname)
  			VALUES (1746, 'john', 'smith');  

- Step 5: Fetch the data fom users. At the cqlsh prompt type:

 		- SELECT * FROM users;
You should see the following output:

 		- user_id | fname | lname
		 ---------+-------+-------
    	     1745 |  john | smith
    		 1744 |  john |   doe
    		 1746 |  john | smith
		  
- Step 6: You can retrieve data about users whose last name is smith by creating an index, then querying the table as follows:

 		CREATE INDEX ON users (lname);

		SELECT * FROM users WHERE lname = 'smith';

		You shoud see the following output:

 		user_id | fname | lname
		--------+-------+-------
    	   1745 |  john | smith
    	   1746 |  john | smith		  

If you try running this query without creating the index, you will get an error.

#### Writing Applications
Applications can be written over Cassandra in a variety of different languages. For the applications to connect to and query Cassandra, a database
driver is required for the language of choice. A full list of CQL drivers can be found on the
[ClientOptions](http://wiki.apache.org/cassandra/ClientOptions) page. For the purposes of this lab we will use Python which requires the [Data Stax
Python Driver](https://github.com/datastax/python-driver). You can install the python driver by typing the following command:

	sudo pip install cassandra-driver   
 

#### Example: Python application
The `lab7` folder contains a sample python application file `example.py`. The application creates a keyspace, a table (`mytable`), queries the table
and displays the query results. To run the application open a terminal and `cd` into the `lab7` folder. Type the following:

	chmod 755 example.py
	./example.py

Running the example python application should give an output like this:

	key5 a b
	key5 b b
	key6 a b
	key6 b b
	key0 a b
	key0 b b
	.
	.
	.

---

### Assignment Part 1
Consider the relational schema given in `schema.txt` in the `lab7` folder. The schema creates a database called `ctr` (click-through-rate) with two tables:
`clicks` and `impressions`, and inserts some data into it. The `clicks` table maintains for each OwnerId and AdId, the number of clicks that it has
received and the `impressions` table maintains for each OwnerId and AdId, the number of impressions of the AdId that we shown. 

- Create a Cassandra database using the schema. Although Cassandra exposes an SQL-like API, it does not allow joins. Hence the data must be stored in a **denormalized** fashion in a single table, so you have to modify the schema appropriately.

- Write CQL queries for the following:
 	- Find the numClicks for OwnerId = 1, AdId = 3.
 	- Find the numClicks for OwnerId = 2.

- On similar lines write a python application to create an appropriate schema, insert data, and do the following 4 tasks.
 	- Find the ctr (numClicks/numImpressions) for each OwnerId, AdId pair.
 	- Compute the ctr for each OwnerId.
 	- Compute the ctr for OwnerId = 1, AdId = 3.
 	- Compute the ctr for OwnerId = 2.
 
 
### Submission
Submit the following using the provided template *submission.txt* file.

- CQL Queries that you wrote
- Python file for the Cassandra application.
- Output of running the Cassandra application in a text file.

---

## Part 2: MongoDB
[MongoDB](http://www.mongodb.org/) is a document oriented NoSQL database. MongoDB supports storage of data as JSON documents with dynamic schemas and enables execution of field, range queries and regular expression searches on these documents. More details on the features and limitations can be found [here](http://en.wikipedia.org/wiki/MongoDB).  

### Installing MongoDB

MongoDB is already installed on the Virtual Machine, however, you can follow the instructions  [here](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/) to install it again, or on a different machine.


### Using MongoDB

MongoDB provides a shell 'mongo' for basic database operations. Follow the [Getting Started with MongoDB Guide](http://docs.mongodb.org/manual/tutorial/getting-started/) for using the MongoDB database with the 'mongo' shell. Further information on MongoDB can be found in the [MongoDB manual](http://docs.mongodb.org/manual/). Specifically read the [MongoDB CRUD Introduction](http://docs.mongodb.org/manual/core/crud-introduction/) and [MongoDB CRUD Tutorial](http://docs.mongodb.org/manual/applications/crud/) to better understand MongoDB functionality in terms of inserting and querying documents in MongoDB.  

### Assignment Part 2
The lab7 folder contains a JSon dataset called `zipData.json`. Load the data using
[mongoimport](http://docs.mongodb.org/manual/reference/program/mongoimport/#bin.mongoimport) into a collection called `zipcodes`. 

Insert the following document into the same collection.

        { "_id" : "99950", "city" : "KETCHIKAN", "loc" : [ -133.18479, 55.942471 ], "pop" : 422, "state" : "AK" }

Write the following aggregation queries against the data set:

 -  Return cities with population less than 5 million grouped by state.
 -  Return states sorted by their total city population.
 -  Return the cities with minimum population by state.

Finally, write a MapReduce operation to compute, for each state, the average population over the cities associated with the state. 
See [this](http://docs.mongodb.org/manual/core/map-reduce/) for the overview of MapReduce, and
[this](http://docs.mongodb.org/manual/tutorial/map-reduce-examples/) for some examples.

### Submission

Add your MongoDB queries (including import, insert, and MapReduce) and their outputs to the *submission.txt* file.
