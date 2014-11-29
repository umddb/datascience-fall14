# Lab 9

Lab 9 focuses on graph processing, specifically we will work with **Neo4j**, a graph database, and **Spark GraphX**, a batch graph analytics platform.

---

## Part 1: Neo4j

Neo4j is a leading open-source graph database system, perhaps the most widely used one today. 

### Install and Start

1. Download the community edition using: 

`wget http://neo4j.com/artifact.php?name=neo4j-community-2.1.6-unix.tar.gz`

1. Extract the tar file (it may have a name starting with `artifact`) using `tar zxvf`.

1. `cd` into the directory.

1. Start the server by running: `./bin/neo4j`

1. Open your browser and go to: [http://localhost:7474/](https://localhost:7474). Follow the `Jump into code` tutorial which creates a Movie Graph, and illustrates how to run Cypher (Neo4j query
language) queries on it. The UI of the tutorial is somewhat confusing, especially since it also allows you to browse the data graphically. Make sure to scroll down if you
can't find the queries or the next steps in the tutorial.

1. If you prefer to use a shell, in the Terminal, type: `./bin/neo4j-shell`. You can run the same queries, but make sure to terminate with a `;`.

### Assignment Part 1

1. On the movies graph, write a cypher query to find people born in 1964.

1. On the movies graph, write a cypher query to find all co-actors of 'Wil Wheaton'.

1. `states.txt` file contains the GraphX code for creating a graph over states, with edges denoting `border` relationship. Write the Cypher script to create a similar 
graph in Neo4j. 

1. On the `states` graph, write a Cypher query to find which states border both Arizona and Colorado.

1. Find states that are 3 hops away from California, i.e., states that border states that borders states that border California.

---

## Part 2: Spark GraphX

GraphX is a graph analytics platform based on Apache Spark. GraphX does not have a Python API, so you will have to program in Scala.

Scala is a JVM-based functional programming language, but it's syntax and functionality is quite different from Java. 
The [Wikipedia Article](http://en.wikipedia.org/wiki/Scala_%28programming_language%29) is a good start to learn about Scala, 
and there are also quite a few tutorials out there. For this assignment, we will try to minimize the amount of Scala you have
to learn and try to provide sufficient guidance.

Following are brief step-by-step instructions to get started with GraphX. The [GraphX Getting Started
Guide](http://spark.apache.org/docs/latest/graphx-programming-guide.html#getting-started) goes into much more depth about the data model, and the functionalities.
The following examples are taken either from that guide, or from [another guide](https://github.com/amplab/datascience-sp14/blob/master/lab10/graphx-lab.md) by the authors.

We will use the *Spark Scala Shell* directly. It might be better for you to write your code in a text editor and cut-n-paste it into the shell.

1. Start the Spark shell. This is basically a Scala shell with appropriate libraries loaded for Spark, so you can also run Scala commands here directly. Here `SPARK_HOME`
denotes the directory where you have extracted Spark (for previous assignments).
```
SPARK_HOME/bin/spark-shell
```
1. Import the GraphX Packages. We are ready to start using GraphX at this point.
```
import org.apache.spark.graphx._
import org.apache.spark.graphx.lib._
import org.apache.spark.rdd.RDD
```
1. Load some data. First we will define two arrays.
```
val vertexArray = Array(
  (1L, ("Alice", 28)),
  (2L, ("Bob", 27)),
  (3L, ("Charlie", 65)),
  (4L, ("David", 42)),
  (5L, ("Ed", 55)),
  (6L, ("Fran", 50))
  )
val edgeArray = Array(
  Edge(2L, 1L, 7),
  Edge(2L, 4L, 2),
  Edge(3L, 2L, 4),
  Edge(3L, 6L, 3),
  Edge(4L, 1L, 1),
  Edge(5L, 2L, 2),
  Edge(5L, 3L, 8),
  Edge(5L, 6L, 3)
  )
```

4. Then we will create the graph out of them, by first creating two RDDs. The first two statements create RDDs by using the `sc.parallelize()` command.
```
val vertexRDD: RDD[(Long, (String, Int))] = sc.parallelize(vertexArray)
val edgeRDD: RDD[Edge[Int]] = sc.parallelize(edgeArray)
val graph: Graph[(String, Int), Int] = Graph(vertexRDD, edgeRDD)
```

5. The Graph class supports quite a few operators, most of which return an RDD as the type.
    - `graph.vertices.collect()`: `graph.vertices` just returns the first RDD that was created above, and `collect()` will get all the data from the RDD and print it (this should only be done for small RDDs)
    - `graph.degrees`: This returns an RDD with the degree for each vertex -- use `collect()` to print and see
See the Getting Started guide for other built-in functions.


6. The following code finds the users who are at least 30 years old using `filter`.
```
graph.vertices.filter { case (id, (name, age)) => age > 30 }.foreach { case (id, (name, age)) => println(name + " is " + age) }
```

`case` is a powerful construct in Scala that is used to do pattern matching.

7. Graph Triplets: One of the core functionalities of GraphX is exposed through the RDD `triplets`. There is one triplet for each edge, that contains information about
both the vertices and the edge information. Take a look through:
`graph.triplets.collect()`

The output is somewhat hard to parse, but you can see the first entry is: `((2,(Bob,27)),(1,(Alice,28)),7)`, i.e., it contains the full information for both the endpoint
vertices, and the edge information itself. 

More specifically, a triplet has the following fields: `srcAttr` (the source vertex property), `dstAttr`, `attr` (the edge property), `srcID` (source vertex Id), `dstId`

The following commands will print out information for each edge using the triplets. Note that the following would be hard to do without using triplets, because the data is
split across multiple RDDs.

`graph.triplets.foreach {t => println("Source attribute: " + t.srcAttr + ", Destination attribute: " + t.dstAttr + ", Edge attribute: " + t.attr)}`

The following command shows another use of `case` to retrieve information from within `srcAttr`. This is the preferred way of doing `casting` in Scala.

`graph.triplets.foreach {t => t.srcAttr match { case (name, age) => println("Source name: " + name)} }`

8. The `subgraph` command can be used to create subgraphs by applying predicates to filters. 

`val olderUsers = graph.subgraph(vpred = (id, attr) => attr._2 > 30)`

You can verify that only the vertices with age > 30 are present by doing `g1.vertices.collect()`


9. The core aggregation primitive in GraphX is called `mapReduceTriplets`, and has the following signature.

```
class Graph[VD, ED] {
  def mapReduceTriplets[A](
      map: EdgeTriplet[VD, ED] => Iterator[(VertexId, A)],
      reduce: (A, A) => A)
    : VertexRDD[A]
}
```

`mapReduceTriplets` applies the user-provided `map` operation to each triplet (in `graph.triplets`), resulting in messages being sent to either of the endpoints. The
messages are aggregate using the user-provided `reduce` function.

The following code uses this operator on a randomly generated graph to compute the average age of older followers for each user. The example is copied verbatim from 
the Getting Started guide, where more details are provided.

```
// Import random graph generation library
import org.apache.spark.graphx.util.GraphGenerators
// Create a graph with "age" as the vertex property.  Here we use a random graph for simplicity.
val graph: Graph[Double, Int] =
  GraphGenerators.rmatGraph(sc, 40, 200).mapVertices( (id, _) => id.toDouble )
// Compute the number of older followers and their total age
val olderFollowers: VertexRDD[(Int, Double)] = graph.mapReduceTriplets[(Int, Double)](
  triplet => { // Map Function
    if (triplet.srcAttr > triplet.dstAttr) {
      // Send message to destination vertex containing counter and age
      Iterator((triplet.dstId, (1, triplet.srcAttr)))
    } else {
      // Don't send a message for this triplet
      Iterator.empty
    }
  },
  // Add counter and age
  (a, b) => (a._1 + b._1, a._2 + b._2) // Reduce Function
)
// Divide total age by number of older followers to get average age of older followers
val avgAgeOfOlderFollowers: VertexRDD[Double] =
  olderFollowers.mapValues( (id, value) => value match { case (count, totalAge) => totalAge / count } )
// Display the results
avgAgeOfOlderFollowers.collect.foreach(println(_))
```

Note the key functions here are the `map` function where for every triplet, a message is generated if the follower is older than the user (i.e., if `srcAttr > dstAttr`). 
The messages are aggregated by summing, so at the end of the `reduce`, we have the total number of older followers as well as a sum of their ages.

The code afterwards simply finds the average age.

### Assignment Part 2

1. Understand and print the output of the `graph.triangleCount` function. The output should look like: "Bob participates in 2 triangles." (with one line per user).

1. Understand and print the output of the `olderUsers.connectedComponents` function. The output should look like: "Bob is in connected component 1" (with one line per user).

1. Modify the `mapReduceTriplets`-based aggregation code above to find, for each user (in the randomly generated graph), the followers with the maximum and second-maximum
ages. 

1. The provided file `states.txt` contains code to generate a small graph where each node is a state, each edge denotes a border between two states and the property of the
edge is the length of the border. Modify the above `mapReduceTriplets`-based aggreagtion code to find, for each state, the state with which it shares the longest border. 
Note that DC is counted is a state here, whereas Alaska and Hawaii are not present in the dataset.
