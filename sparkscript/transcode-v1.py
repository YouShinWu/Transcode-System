from pyspark.context import SparkContext
import os

#video source path hdfs://master:9000/movies
#video output destination hdfs://master:9000/h265_movies_put

#Use this pattern con read rdd element 
# rdd.foreachPartition(f)
# def f(x):
#         for i in x:
#             print(i)


def compressing(x):
    for i in x:
        print(i)
        _get_video_and_get_prepare_and_compressing(i,'h265')
    print('Compressing Finished')

def _get_video_and_get_prepare_and_compressing(video,function_name): #video = ('video_name','hdfs_path_to_video')
    #get video from hdfs
    video_name = video[0].split('.')[0]
    print('mkdir /tmp/'+video_name)
    os.system('mkdir /tmp/'+video_name)
    video_local_src = '/tmp/'+video_name+'/'+video[0]
    print('hadoop fs -get -f '+video[1]+' '+video_local_src)
    os.system('/usr/local/hadoop-3.2.2/bin/hadoop fs -get -f '+video[1]+' '+video_local_src+' 2>&1')

    #create output directoy and out_put_path
    video_output_path = get_prepare(video_name,function_name)+video[0]
    
    #Start_Compressing
    xh265(video_local_src,video_output_path)

    #put video output to hdfs
    destination = '/h265_movies_put/'
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

print('------------Start------------')
path_to_video_src = 'hdfs://master:9000/movies/' 
sc = SparkContext(appName = 'testSpark')
video_name = sc.textFile('hdfs://master:9000/test/playlist.txt')
    # print(video_name.collect())
video_pairs = video_name.map(lambda x:(x,path_to_video_src+x)).foreachPartition(compressing)
print("------------End------------")
exit()