time $SPARK_HOME/bin/spark-submit \
--master yarn \
--deploy-mode cluster \
--driver-memory 6g \
--num-executors 5 \
--executor-memory 4g \
--executor-cores 4 \
/home/transcode-v3.py

# $SPARK_HOME/bin/spark-submit \
# --master local[6] \
# /home/transcode-v3.py