#!/bin/bash
source $HOME/.profile
hdfs namenode -format 
hdfs namenode &  
hdfs datanode & 
yarn resourcemanager & 
yarn nodemanager & 
mapred historyserver & 