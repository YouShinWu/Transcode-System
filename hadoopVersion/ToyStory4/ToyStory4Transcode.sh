#!/bin/bash
id="h265ToyStory4"
mkdir -p /tmp/$id
host=`hostname`
pwd=`pwd`
uid=`whoami`
put_dir='/h265_movies_put/'



true > a

while read line; do
  echo $line
  input=$line
  filename=`basename $input `
  echo $input
  echo "$uid@$host> hadoop fs -get -f $input /tmp/$id/$filename"
  /usr/local/hadoop-3.2.2/bin/hadoop fs -get -f $input /tmp/$id/$filename 2>&1

  echo "/ffmpeg/ffmpeg -i /tmp/$id/$filename -c:v libx265 -x265-params pools=4 /tmp/$id/h265-$filename"
  /ffmpeg/ffmpeg -i /tmp/$id/$filename -c:v libx265 -x265-params pools=4 /tmp/$id/h265-$filename 2>&1
  #echo "$uid@$host> ffmpeg -y -i /tmp/$id/$filename -s 480*360 -vcodec h264 -b:v 172k -ab 126k -r 20 -ar 44100 -acodec aac -strict -2  /tmp/$id/$filename/output-$filename"
  #/ffmpeg/ffmpeg -y -i /tmp/$id/$filename -s 480*360 -vcodec h264 -b:v 172k -ab 126k -r 20 -ar 44100 -acodec aac -strict -2 /tmp/$id/output-$filename 2>&1
  #echo "$uid@$host> hadoop fs -put /tmp/$id/out-put-$filename ${put_dir}"
  echo "$uid@$host> hadoop fs -put -f /tmp/$id/h265-$filename ${put_dir}"
  /usr/local/hadoop-3.2.2/bin/hadoop fs -put -f /tmp/$id/h265-$filename ${put_dir} 2>&1
  #echo "$uid@$host> hadoop fs -chown $id ${put_dir}/output-$filename.mpg"
done

rm -f a
