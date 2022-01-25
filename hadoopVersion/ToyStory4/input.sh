#!/bin/bash
pwd=`pwd`
tmp_file='movies_tmp.txt'
num=13           ################TaskTracker数量
true > ${tmp_file}
echo "rm movies_a*"
rm movies_a*

hadoop fs -mkdir /movies 2>&1
hadoop fs -put -f ./ToyStory4.000* /movies 2>&1

hadoop fs -mkdir /movies_input
hadoop fs -rm /movies_input/movies_*  2>&1
for i in `ls ToyStory4.[0-9][0-9][0-9][0-9][0-9].mp4`; do echo /movies/$i >> ${tmp_file};done
rows="$(($(wc -l ${tmp_file}|cut -d' ' -f1)/$num))" 
echo $num
echo $rows
split -l $rows ${tmp_file} movies_
echo "hadoop fs -put movies_[a-z0-9][a-z0-9] /movies_input"
hadoop fs -put movies_[a-z0-9][a-z0-9] /movies_input 2>&1
echo "hadoop fs -mkdir /test"
hadoop fs -mkdir /test 2>&1
echo "hadoop fs -mkdir /h265_movies_put"
hadoop fs -mkdir /h265_movies_put 2>&1
