# Lab 6

Lab 6 focuses on distributed, data-parallel, batch-processing platforms, and has two parts: (1) Hadoop, and (2) Spark.

---

## Part 1: Hadoop

[Hadoop](http://hadoop.apache.org/) is an open-source software framework for storage and large-scale processing  of datasets on clusters of commodity hardware. The Apache Hadoop Software Library provides fault tolerant distribution of data and computation and is designed to scale to 1000s of machines each offering local computation and storage.

The project includes: 

- **Hadoop Common**: The common utilities that support the other Hadoop modules. 
- **Hadoop Distributed File System (HDFS™):** A distributed file system that provides high-throughput access to application data.
- **Hadoop YARN:**:  A framework for job scheduling and cluster resource management.
- **Hadoop MapReduce**: A YARN-based system for parallel processing of large data sets.      
---



### Installing Hadoop

For this lab we will be using [CDH](http://www.cloudera.com/content/cloudera/en/products-and-services/cdh.html), a popular distribution of Apache Hadoop. CDH includes the core components of Hadoop along with a user interface for job extensive monitoring. 

The lab will require you to setup a few basic dependencies required to run HDFS and MapReduce with YARN on a single machine. We will be using CDH version 5.1.2 for the lab. The instructions below would work for installing CDH on Linux and MAC OX. For Windows you would need to install CDH on the Ubuntu VM runinng on Virtual Box. 

#### Dependencies

- You would need java version [JDK 1.7 u67 ](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) for CDH5.1.2.
- If you are using the Linux VM, java 1.7 is already installed. 
- If you are using a Mac, verify your java path. It should be: `/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home`
	
		 
	
#### Installing CDH


Use the following simple instructions to install CDH. 

- Start by pulling the latest version of the git repository, which contains a `lab6` folder.
- The `lab6` folder has a script called `setup.sh`.
- Open a terminal in the Linux VM and `cd` into the `lab6` folder.
- Type: 
	- chmod 755 setup.sh
	- ./setup.sh
- Check whether HADOOP_HOME has been set (`echo $HADOOP_HOME`)
    - If not, try `source ~/.profile`
    - If not, check if `~/.profile` sets HADOOP_HOME toward the end and email us
		
---

#### Starting the CDH Services

You can now start/stop the services for CDH. Run the following script in the lab6 directory to start HDFS and YARN CDH services.
- Open a terminal and cd into the lab6 folder. Type the following:
	- ./start.sh
- To check all the services are running, click and open the following URLs. More details on what these services do can be found on the CDH Documentation.
    - Service HDFS
        - NameNode: [URL](http://localhost:50070/dfshealth.html)
        - DataNode: [URL](http://localhost:50075/browseDirectory.jsp?dir=%2F&nnaddr=127.0.0.1:8020)
    - Service YARN
        - Resource Manager: [URL](http://localhost:8088/cluster)
        - Node Manager: [URL](http://localhost:8042/node)
        - MapReduce Job History Server: [URL](http://localhost:19888/jobhistory/app)

### Testing 

#### To Check HDFS functionality do the following:
- Open a terminal and type:

```
echo "This is an HDFS test" >> file.txt
hadoop fs -mkdir /tmp1
hadoop fs -put file.txt /tmp1/
hadoop fs -cat /tmp1/file.txt
```

- You should see "This is an HDFS test", otherwise something is broken

#### Testing a sample application (Pi)
- Open a terminal and type:

  `hadoop jar ~/cloudera/cdh5.1/hadoop-2.3.0-cdh5.1.2/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.3.0-cdh5.1.2.jar pi 2 10000`
- You should get an approximate value of Pi as the console output.
- You should also see the details of the appliation by clicking on the Resource Manager [URL](http://localhost:8088/cluster).
	 
### Writing and runnning your own Hadoop jobs/applications

#### Example: WordCount v1.0
We have provided a sample word count application in the `lab6` folder. The following steps would be required to create a jar and running the word count application as a
hadoop job. For a more detailed explaination for running hadoop jobs, follow this [tutorial](http://hadoop.apache.org/docs/r1.2.1/mapred_tutorial.html).

- `mkdir ~/hadoop_apps`
- Copy the word count application WordCount.java into ~/hadoop_apps
- `cd hadoop_apps`
- `mkdir wordcount_classes`
- Compile the word count program using the following command:

	 `javac -classpath ${HADOOP_HOME}/share/hadoop/common/hadoop-common-2.3.0-cdh5.1.2.jar:${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.3.0-cdh5.1.2.jar -d wordcount_classes WordCount.java`
- Make a jar file by typing the following command:

	 `jar cvf wordcount.jar -C wordcount_classes org`
- Make the appropriate directories in HDFS and load input data (say `test.txt` which coutains some text of your choice.)

		hadoop fs -mkdir wordcount
		hadoop fs -mkdir wordcount/input
		hadoop fs -put test.txt wordcount/input/ 
- Run the word count application:
		 hadoop jar wordcount.jar org.myorg.WordCount wordcount/input wordcount/output		  	 
 
- You can monitor your application and its log history here: [Resource Manager](http://localhost:8088/cluster)

- Once the program runs successfully the output of the word count application can be seen by using the following command:
	    hadoop fs -cat wordcount/output/part-00000  
		

- **Note**: Before running the word count application you would need to remove the output directory otherwise you will get an error.
		hadoop fs -rm -r -f wordcount/output 
		
		 
- To understand the data flow and code of the word count application, you can go through the walk through here: [Walk_Though](http://hadoop.apache.org/docs/r1.2.1/mapred_tutorial.html#Source+Code)  
 
#### Multistage MapReduce
Certain jobs require to be composed as multistage MapReduce jobs. Multistage MapReduce jobs can be chained together easily as each MapReduce job reads/writes its
input/output from/to HDFS. For example: If an application is composed of two MapReduce jobs MR1 and MR2. MR1 can read input from an input folder on HDFS, write its output to
an HDFS in a tmp folder. MR2 will use tmp as its input folder and write its output to an output folder on HDFS. The following commands illustrate an application myApp
composed of Job1 and Job2.

 		hadoop jar job1.jar org.myorg.Job1 myApp/input myApp/tmp
 		hadoop jar job2.jar org.myorg.Job2 myApp/tmp myApp/output

The two commands can be given at command line or glued together as a simple shell script.            

---

### Assignment Part 1

- [Bigrams](http://en.wikipedia.org/wiki/Bigram) are simply sequences of two consecutive words. For example, the previous sentence contains the following bigrams: "Bigrams
are", "are simply", "simply sequences", "sequences of", etc.
- Modify the word count application to write a **Bigram Counting** application that can be composed as a two stage Map Reduce job. 
    - The first stage counts bigrams.
    - The second stage MapReduce job takes the output of the first stage (bigram counts) and computes for each word the top 5 bigrams by count that it is a part of, and the bigram count associated with each.
- You can use the sample collection input file "bible+shakes.nopunc.gz" provided in the lab6 folder to test your programs.
 
### Submission
Submit the following files:

- Bigram MapReduce application code for the two stages (.java file).
- Output of the two stage MapReduce job as a text file.

---

## Part 2: Spark

[Apache Spark](https://spark.apache.org) is a relatively new cluster computing framework, developed originally at UC Berkeley. It significantly generalizes
the 2-stage Map-Reduce paradigm, and is instead based on the abstraction of **resilient distributed datasets (RDDs)**. An RDD is basically a distributed collection 
of items, that can be created in a variety of ways. Spark provides a set of operations to transform one or more RDDs into an output RDD, and analysis tasks are written as
chains of these operations.

Spark can be used with the Hadoop ecosystem, including the HDFS file system and the YARN resource manager. 

### Installing Spark

1. Download the Spark package at http://spark.apache.org/downloads.html. We will use **Version 1.1.0, Pre-built for CDH 4**.

2. Move the extract file to the lab6 directory in the git repository, and uncompress it using: 

`tar zxvf spark-1.1.0-bin-cdh4.tgz`

3. This will create a new directory: `spark-1.1.0-bin-cdh4` -- `cd` into that directory.

We are ready to use Spark. 

### Using Spark

Spark provides support for three languages: Scala (Spark is written in Scala), Java, and Python. We will use Python here -- you can follow the instructions at the tutorial
and quick start (http://spark.apache.org/docs/latest/quick-start.html) for other languages. 

1. `./bin/pyspark`: This will start a Python shell (it will also output a bunch of stuff about what Spark is doing). The relevant variables are initialized in this python
shell, but otherwise it is just a standard Python shell.

2. `>>> textFile = sc.textFile("README.md")`: This creates a new RDD, called `textFile`, by reading data from a local file. The `sc.textFile` commands create an RDD
containing one entry per line in the file.

3. You can see some information about the RDD by doing `textFile.count()` or `textFile.first()`, or `textFile.take(5)` (which prints an array containing 5 items from the RDD).

4. We recommend you follow the rest of the commands in the quick start guide (http://spark.apache.org/docs/latest/quick-start.html). Here we will simply do the Word Count
application.

### Word Count Application

The following command (in the pyspark shell) does the word count.

`>>> counts = textfile.flatMap(lambda line: line.split(" ")).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)`

Here is the same code without the use of `lambda` functions.

```
def split(line): 
    return line.split(" ")
def generateone(word): 
    return (word, 1)
def sum(a, b):
    return a + b

textfile.flatMap(split).map(generateone).reduceByKey(sum)
```

The `flatmap` splits each line into words, and the following `map` and `reduce` do identical things to the Hadoop MapReduce example we saw.

The `lambda` representation is more compact and preferable, especially for small functions, but for large functions, it is better to separate out the definitions.

### Running it as an Application

Instead of using a shell, you can also write your code as a python file, and *submit* that to the spark cluster. The `lab6` directory contains a python file `wordcount.py`,
which runs the program in a local mode. To run the program, do:
`./bin/spark-submit wordcount.py`

### More...

We encourage you to look at the [Spark Programming Guide](https://spark.apache.org/docs/latest/programming-guide.html) and play with the other RDD manipulation commands. 
You should also try out the Scala and Java interfaces.

### Assignment Part 2

Modify the `wordcount.py` to: (1) count bigrams instead of words, and (2) for each word, find the top 5 bigrams it is part of, along with their counts.

### Submission

Submit the following files:

- Your python script.
- The output file.
