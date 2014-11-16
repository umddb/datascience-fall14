# Lab 8

Lab 8 focuses on distributed stream processing platforms, and has two parts dealing with state-of-the-art stream processing platforms: (1) Storm, and (2) Spark Streaming.

---

## Part 1: Storm

[Storm](https://storm.apache.org/documentation/Tutorial.html) is a distributed real-time computation system. Similar to how Hadoop provides a set of general primitives for doing batch processing, Storm provides a set of general primitives for doing realtime computation. Storm is simple, can be used with any programming language, is used by many companies.

### Task Model
To do real-time computation on Storm, you create what are called topologies. A topology is a graph of computation. Each node in a topology contains processing logic, and links between nodes indicate how data should be passed around between nodes. Please read through the [tutorial](https://storm.apache.org/documentation/Tutorial.html) for more details. 

### Running a sample application

Follow the instructions to get started with a basic application.

- We will use `Maven` for building both the project. Maven is a build automation tool used primarily for Java projects, and describes how a software 
is built and its dependencies. 
    - Install maven using: `sudo apt-get install maven`
    - Confirm it is working by running: `mvn --version`
- Pull the `lab8` git repository.
- `cd Storm-Assignment`
- `mvn compile`: This will download all the required dependencies, including storm, and build the sample application.
    - Take a look at `pom.xml` if you want to see how the dependencies are described.
- Run the sample application: 

        mvn compile exec:java -Dstorm.topology=org.umd.assignment.WordCountTopology

- You can reduce the unnecessary output by using unix tools:

        mvn compile exec:java -Dstorm.topology=org.umd.assignment.WordCountTopology | grep "count default" | awk -F'[' '{print $3}'| awk -F']' '{print $1}' | awk -F',' '{print $1" "$2}'

- Note that this application will stop after 10 seconds. You can change that by modifying the `WordCountTopology.java` file.

### What does the application do?

The provided WordCountTopology application prints the counts of the words in the randomly generated sentences. 
Specifically, it:
	(a) Initializes the Spout named "sentences" that generates a stream of random sentences
	(b) Creates a Bolt named "words" that takes tuples from "sentences" and splits them into words
	(c) Creates another Bolt "count" that takes tuples from "words" and counts the frequency of each word
	
The workflow (a-c) could be seen in the `WordCountTopology.java` file underneath `src`.

---

### Assignment Part 1

In this assignment you will fetch live tweets form Twitter, filter them based on the word "Obama" and find out what are the words that mostly co-occur (in terms of their
frequency) with Obama. For example, if a tweet says "Obama loves big-data", then counter for both the words "loves" and "big-data" should be increased by one. You
will also need to ignore any stop-words (words like a, an, the etc.) from consideration. We have provided a file `StopWords.txt` for that purpose.  

You would need to make changes in the following two files: `WordCountTopology.java`, and `TwitterSampleSpout.java`.

- Tasks
 	- Open both the files, read the comments
	- Complete the tasks in their order [i.e., task 0 should be done first]
	- Run the program for 10 minutes [i.e., task 4] and report the results. Note that, every time you run your program the output would be different. 

### Submission
Submit the following using the provided template `submission.txt` file.

- Your `WordCountTopology.java` and `TwitterSampleSpout.java` files
- The list of words that mostly co-occur with Obama, sorted by their frequency (in some execution run)

---


## Part 2: Spark Streaming

[Spark Streaming](https://spark.apache.org/docs/latest/streaming-programming-guide.html) is an extension of the core Spark API (we have covered Spark in lab6) that allows enables scalable, high-throughput, fault-tolerant stream processing of live data streams. Similar to Strom, Spark Streaming can ingest data from  many sources like Kafka, Flume, Twitter, ZeroMQ, Kinesis or plain old TCP sockets and can process the stream using complex algorithms expressed with high-level functions like map, reduce, join and window.

Even though in lab6 we have written a Spark program in Python, Spark Streaming doesn't have any Python API yet. We will use Spark Streaming Java API for this assignment. 


### Installing Spark Streaming

- You should already have Spark installed. Follow directions from `lab6` to do so if not.

---

#### Using Spark Streaming

(If you are doing this assignment first, make sure to install `maven` and do a `git pull` to `lab8` directory.)

Running a Netcat Server:	
- Open a new terminal and type `nc -lk 9999`
- This starts Netcat Server bound to port 9999. You can now type on this terminal to send data to the Netcat server
- Any client listening to port 9999 will receive anything thats typed on the Netcat Server terminal 


Running the provided Spark application:
- `cd Spark-Assignment`
- `mvn package`: This will compile and create a `jar` file (in target/ directory).
- `YOUR_SPARK_HOME/bin/spark-submit --class JavaNetworkWordCount --master 'local[4]' target/streaming-project-1.0.jar`
      - Make sure to replace YOUR_SPARK_HOME with the appropriate directory (where you downloaded Spark)

Note: The `Spark-Assignment/log4j.properties` suppresses all the extraneous output, so the first output you will see will be after 10 seconds.

### What does the program do?
		

The main file here is: `JavaNetworkWordCount.java` underneath `src`
- It starts listerning to port 9999 (where the Netcat server is sending data)
- It reads each line from the Netcat server, splits them by space, produces a tuple (word, 1) for each word, and then counts them
- Note that the program sets a *batch size* of 10 seconds, which means that the line "wordCounts.print();" will be executed every 10 seconds. *Batch size* is a key notion in Spark Streaming. Spark streaming processes all the data tuples it has received at the end of each batch interval.
- Anything you *type on the Netcat server terminal* Spark Streaming will process that. Spark Streaming will print an empty line (with ending time of the current batch) if nothing is typed on the Netcat terminal in a batch window of 10 seconds. 
  
---

### Assignment Part 2


For this assignment we will learn to implement sliding window using Spark streaming. To be specific, the task is to count the number of times '#Obama' appeared in the Netcat
server between last 30 seconds and current time (i.e., 30s of *window interval*). Moreover, we want to do this computation every 10 seconds (i.e., 10s of *sliding
        parameter*). Note that these two concepts are different from the *batch size* which is Spark specific. For more details read the [Window
Operation](https://spark.apache.org/docs/latest/streaming-programming-guide.html) section. And example input to the Netcat server could be found in `NetcatInputExample.txt`. You can simply copy the text from the file and paste on the Netcat server terminal multiple times with varying time interval.   

You would need to make changes in the following file: `Assignment.java`

You can run it using the same command as before with replacing JavaNetworkWordCount with Application, i.e., :
     `YOUR_SPARK_HOME/bin/spark-submit --class Assignment --master 'local[4]' target/streaming-project-1.0.jar`

### Submission
Submit your Assignment.java file, and the output of one execution run (you don't need to submit the netcat input) using the provided `submission.txt`.
