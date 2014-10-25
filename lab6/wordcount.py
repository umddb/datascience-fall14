from pyspark import SparkContext, SparkConf

conf = SparkConf().setAppName("WordCount").setMaster("local")

sc = SparkContext(conf=conf)

textFile = sc.textFile("bible+shakes.nopunc")

counts = textFile.flatMap(lambda line: line.split(" ")).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)

print counts.sort().take(100)

counts.saveAsTextFile("output")
