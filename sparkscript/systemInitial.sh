echo "/usr/local/hadoop-3.2.2/bin/hadoop fs -mkdir /test 2>&1"
/usr/local/hadoop-3.2.2/bin/hadoop fs -mkdir /test 2>&1
echo "/usr/local/hadoop-3.2.2/bin/hadoop fs -mkdir /spark-event-log 2>&1"
/usr/local/hadoop-3.2.2/bin/hadoop fs -mkdir /spark-event-log
echo "Upload video"
python ./updateVideoClips.py
echo "/usr/local/hadoop-3.2.2/bin/hadoop fs -put ./ToyStory4-playlist.txt /test"
/usr/local/hadoop-3.2.2/bin/hadoop fs -put ./ToyStory4-playlist.txt /test
echo "/usr/local/hadoop-3.2.2/bin/hadoop fs -put ./Batman-playlist.txt /test"
/usr/local/hadoop-3.2.2/bin/hadoop fs -put ./Batman-playlist.txt /test

echo "Start Spark history server"
$SPARK_HOME/sbin/start-history-server.sh