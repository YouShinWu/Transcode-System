FROM ubuntu:20.04

USER root

ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install \
    ssh \
    pdsh \
    git \
    nano

ENV PDSH_RCMD_TYPE=ssh

#java
RUN apt install -y openjdk-8-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

#Hadoop
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
RUN tar -xvzf hadoop-3.2.2.tar.gz -C /usr/local


ENV HADOOP_HOME=/usr/local/hadoop-3.2.2
ENV PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME

#Spark
RUN wget https://dlcdn.apache.org/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
RUN tar -xvzf spark-3.1.2-bin-hadoop3.2.tgz -C /usr/local
RUN mv /usr/local/spark-3.1.2-bin-hadoop3.2 /usr/local/spark-3.1.2

ENV SPARK_HOME=/usr/local/spark-3.1.2
ENV PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:$PATH

#gpu for ffmpeg
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

#ffmpeg
RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

RUN apt-get update -qq && apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
  libssl-dev \
  libunistring-dev \
  libaom-dev \
  nasm \
  libx264-dev \
  libx265-dev \
  libnuma-dev \
  libvpx-dev \
  libfdk-aac-dev \
  libopus-dev 


COPY install.sh ./
RUN chmod +x install.sh
RUN ./install.sh


ENV LD_LIBRARY_PATH=/usr/local/lib/

#Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
RUN chmod +x ./Anaconda3-2021.05-Linux-x86_64.sh
RUN ./Anaconda3-2021.05-Linux-x86_64.sh -b
RUN mv ~/anaconda3 /usr/local/anaconda3

RUN mkdir mkdir -p $HADOOP_HOME/data/namenode && mkdir -p $HADOOP_HOME/data/datanode

RUN ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P "" \
    && cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys
RUN chmod 600 $HOME/.ssh/authorized_keys

RUN mkdir config_files
COPY ./config_files ./config_files
RUN mv /config_files/hadoop_config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml \
  && mv /config_files/hadoop_config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
  && mv /config_files/hadoop_config/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml \
  && mv /config_files/hadoop_config/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml \
  && mv /config_files/hadoop_config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh \
  && mv /config_files/hadoop_config/workers $HADOOP_HOME/etc/hadoop/workers \
  && mv /config_files/hadoop_config/start-all.sh $HADOOP_HOME/sbin/start-all.sh \
  && mv /config_files/hadoop_config/stop-all.sh $HADOOP_HOME/sbin/stop-all.sh \
  && mv /config_files/hadoop_config/start-dfs.sh $HADOOP_HOME/sbin/start-dfs.sh \
  && mv /config_files/hadoop_config/stop-dfs.sh $HADOOP_HOME/sbin/stop-dfs.sh \
  && mv /config_files/hadoop_config/start-yarn.sh $HADOOP_HOME/sbin/start-yarn.sh \
  && mv /config_files/hadoop_config/stop-yarn.sh $HADOOP_HOME/sbin/stop-yarn.sh \
  && mv /config_files/spark_config_file/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf \
  && mv /config_files/spark_config_file/workers $SPARK_HOME/conf/workers \
  && mv /config_files/spark_config_file/log4j.properties $SPARK_HOME/conf/log4j.properties \
  && mv /config_files/spark_config_file/spark-env.sh $SPARK_HOME/conf/spark-env.sh \
  && mv /config_files/ssh_config_file/ssh_config /etc/ssh/ssh_config \
  && mv /config_files/ssh_config_file/sshd_config /etc/ssh/sshd_config \
  && rm -r config_files

RUN mkdir /tmp/spark_log
RUN echo "include /usr/local/lib/" >> /etc/ld.so.conf
RUN ldconfig
#Anaconda
ENV ANACONDA_HOME=/usr/local/anaconda3
ENV PATH=${ANACONDA_HOME}/bin:$PATH
#pyspark
ENV PYSPARK_DRIVER_PYTHON=$ANACONDA_HOME/bin/python
ENV PYSPARK_PYTHON=$ANACONDA_HOME/bin/python

COPY ./start_hadoop_spark.sh ./
RUN mkdir /sparkscript
COPY ./sparkscript /sparkscript
RUN mv /sparkscript/* /home
EXPOSE 50010 50020 50070 50075 50090 8020 9000 4040 4041 7077
EXPOSE 10020 19888
EXPOSE 8030 8031 8032 8033 8040 8042 8088
EXPOSE 49707 2122 7001 7002 7003 7004 7005 7006 7007 8888 9000

ENTRYPOINT service ssh start; bash