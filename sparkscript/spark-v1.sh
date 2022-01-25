$SPARK_HOME/bin/spark-submit \
--master yarn \
--deploy-mode cluster \
--driver-memory 6g \
--driver-cores 16 \
--executor-memory 4g \
--executor-cores 13 \
/home/transcode-v1.py