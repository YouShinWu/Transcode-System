from pyspark.context import SparkContext
from pyspark import SparkConf
import os

#video source path hdfs://master:9000/movies
#video output destination hdfs://master:9000/h265_movies_put

#Use this pattern con read rdd element 
# rdd.foreachPartition(f)
# def f(x):
#         for i in x:
#             print(i)

# def f(x):
#     print(x)

def transcode(video):
    print(video[0])
    _get_video_and_get_prepare_and_compressing(video,'h265')
    print('transcoding Finished')

def _get_video_and_get_prepare_and_compressing(video,function_name): #video = ('video_name','hdfs_path_to_video')
    #get video from hdfs
    video_name = video[0].split('.')[0]
    print('mkdir /tmp/'+video_name)
    os.system('mkdir /tmp/'+video_name)
    video_local_src = '/tmp/'+video_name+'/'+video[0]
    print('hadoop fs -get -f '+video[1]+' '+video_local_src)
    os.system('/usr/local/hadoop-3.2.2/bin/hadoop fs -get -f '+video[1]+' '+video_local_src+' 2>&1')

    #create output directoy and out_put_path (local)
    video_output_path = get_prepare(video_name,function_name)+video[0]
    
    #Start_transcoding
    xh265(video_local_src,video_output_path)

    #put video output to hdfs
    destination = '/h265-'+video_name+'/'
    put_video_to_hdfs(video_output_path,destination)
    

def get_prepare(video_name,function_name):
    print('mkdir /tmp/'+video_name+'/'+function_name)
    os.system('mkdir /tmp/'+video_name+'/'+function_name)
    video_output_path = '/tmp/'+video_name+'/'+function_name+'/'+function_name+'-'
    return video_output_path
    

def xh265(video_input_path,video_output_path):
    print('Start xh265.......')
    print('/ffmpeg/ffmpeg -i '+video_input_path+' -c:v libx265 -x265-params pools=4 '+video_output_path)
    os.system('/ffmpeg/ffmpeg -i '+video_input_path+' -c:v libx265 -x265-params pools=4 '+video_output_path)

def put_video_to_hdfs(video_output_path,destination):
    print('Put output video to hdfs.....')
    print('/usr/local/hadoop-3.2.2/bin/hadoop fs -put -f '+video_output_path+' '+destination)
    os.system('/usr/local/hadoop-3.2.2/bin/hadoop fs -put -f '+video_output_path+' '+destination+' 2>&1')

VideoName = 'Batman'

Create_hdfs_output_dict = '/usr/local/hadoop-3.2.2/bin/hadoop fs -mkdir /h265-'+VideoName+'/'
os.system(Create_hdfs_output_dict)
print(Create_hdfs_output_dict)

conf = SparkConf()
conf.set('spark.app.name','Test')
conf.set('spark.default.parallelism','8')
conf.set('spark.ui.showConsoleProgress','true')
conf.set('spark.driver.cores','1')
# conf.set('spark.driver.memory'.'2g')
conf.set('spark.executor.memory','9g')
conf.set('spark.executor.cores','1') # 1 in yarn 
conf.set('spark.yarn.am.cores','1')
conf.set('spark.executor.instances','9')
conf.set("spark.scheduler.mode", "FAIR")
# spark.dynamicAllocation.enabled    true
# spark.dynamicAllocation.initialExecutors 3
# spark.dynamicAllocation.minExecutors   3
# spark.dynamicAllocation.maxExecutors  5
# spark.shuffle.service.enabled      true
# spark.dynamicAllocation.shuffleTracking.enabled   true

print('Start........')
path_to_video_src = 'hdfs://master:9000/'+VideoName+'/' 
sc = SparkContext(conf = conf)
print(sc.getConf().getAll())
video_name = sc.textFile('hdfs://master:9000/test/'+VideoName+'-playlist.txt',8)
    # print(video_name.collect())
video_pairs = video_name.map(lambda x:(x,path_to_video_src+x)).foreach(transcode)
print("End..........")
exit()