#!/bin/bash
mkdir $HOME/cassandra
cd $HOME/cassandra
curl -O http://www.eu.apache.org/dist/cassandra/2.1.1/apache-cassandra-2.1.1-bin.tar.gz
#http://apache.spinellicreations.com/cassandra/2.1.1/apache-cassandra-2.1.1-bin.tar.gz
tar -xvf apache-cassandra-2.1.1-bin.tar.gz
cd -
cp logback.xml $HOME/cassandra/apache-cassandra-2.1.1/conf/
echo 'export CASSANDRA_HOME="${HOME}/cassandra/apache-cassandra-2.1.1"' >> ~/.profile
echo 'JAVA_HOME="/usr/lib/jvm/java-7-openjdk-i386/jre"' >> ~/.profile
echo 'export PATH=${CASSANDRA_HOME}/bin:${JAVA_HOME}/bin:${PATH}' >> ~/.profile

source ~/.profile

mkdir $CASSANDRA_HOME/data
mkdir $CASSANDRA_HOME/data/commitlog
mkdir $CASSANDRA_HOME/data/data
mkdir $CASSANDRA_HOME/data/saved_caches
