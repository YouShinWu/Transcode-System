$SPARK_HOME/bin/spark-submit \
--master yarn \
--deploy-mode cluster \
--driver-memory 6g \
--executor-memory 4g \
--executor-cores 4 \
/home/testSpark.py
4