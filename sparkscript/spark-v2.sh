#REMEMBER create hdfs://master:9000/saprk-event-log 

# time $SPARK_HOME/bin/spark-submit \
# --master yarn \
# --deploy-mode cluster \
# --driver-memory 6g \
# --num-executors 5 \
# --executor-memory 4g \
# --executor-cores 4 \
# /home/transcode-v2.py


time $SPARK_HOME/bin/spark-submit \
--master yarn \
--deploy-mode client \
--driver-memory 2048m \
/home/transcode-v2.py
# --num-executors 5 \
# --executor-memory 1024m \
# --executor-cores 2 \



# $SPARK_HOME/bin/spark-submit \
# --master local[5] \
# /home/transcode-v2.py


#Cluster config
#5 Nodes
#4 cores per Node
#
