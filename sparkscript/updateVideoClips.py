import os

def updateVideoClips(VideoName):
    print('Upload '+VideoName)
    srcVideo = './'+VideoName+'/'+VideoName+'*'
    destination = VideoName
    make_hdfs_dic = '/usr/local/hadoop-3.2.2/bin/hadoop fs -mkdir /'+VideoName+' 2>&1'
    os.system(make_hdfs_dic)
    update = '/usr/local/hadoop-3.2.2/bin/hadoop fs -put '+srcVideo+' /'+destination+' 2>&1' 
    print(update)
    os.system(update)


video_list = ['ToyStory4','Batman']
for i in video_list:
    updateVideoClips(i)