#!/bin/bash
echo "$HADOOP_HOME/bin/hdfs namenode -format"
$HADOOP_HOME/bin/hdfs namenode -format
echo "$HADOOP_HOME/sbin/start-all.sh"
$HADOOP_HOME/sbin/start-all.sh
