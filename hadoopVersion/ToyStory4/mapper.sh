#!/bin/bash



/usr/local/hadoop-3.2.2/bin/hadoop fs -rm -r /h265_movies_put 2>&1
#/opt/hadoop-3.2.2/bin/hadoop fs -rm movies_put/172k-Input4.*

#MR
/usr/local/hadoop-3.2.2/bin/hadoop jar \
/usr/local/hadoop-3.2.2/share/hadoop/tools/lib/hadoop-streaming-3.2.2.jar \
-D mapred.job.queue.name=default \
-D mapreduce.job.name=ToyStory4h265Transcode \
-D mapreduce.reduce.tasks=0 \
-input hdfs://master:9000/movies_input \
-output hdfs://master:9000/h265_movies_put \
-mapper /home/ToyStory4/ToyStory4Transcode.sh \
-file /home/ToyStory4/ToyStory4Transcode.sh \

