FROM ubuntu:16.04

LABEL maintainer "Luigy Machaca <luigy.mach.arc@gmail.com>"

WORKDIR /root


# Install openssh-server, openjdk and wget
#RUN add-apt-repository ppa:openjdk-r/ppa 
#RUN apt-get install -y apt-utils
#RUN apt-get install -y --no-install-recommends apt-utils 
RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y --no-install-recommends openjdk-8-jdk #ok
RUN apt-get install -y --no-install-recommends git 
RUN apt-get install -y --no-install-recommends g++ 
RUN apt-get install -y --no-install-recommends vim 
RUN apt-get install -y --no-install-recommends net-tools
RUN apt-get install -y --no-install-recommends iputils-ping
RUN apt-get install -y --no-install-recommends python-software-properties
RUN apt-get install -y --no-install-recommends scala
RUN apt-get install -y --no-install-recommends openssh-client
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends wget
RUN apt-get install -y --no-install-recommends unzip


## Install hadoop 2.7.3
COPY hadoop-2.7.3/ /opt/hadoop-2.7.3/ 

## Install spark-2.2.0-bin-hadoop2.7.tgz
COPY spark-2.2.0-bin-hadoop2.7/ /opt/spark-2.2.0-bin-hadoop2.7/ 

## Install SBT 
COPY ./sbt.deb /root/ 
RUN dpkg -i sbt.deb
RUN apt-get update
RUN apt-get install sbt
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

## Set environment variable
##SPARK VARIABLES START
ENV SPARK_HOME=/opt/spark-2.2.0-bin-hadoop2.7
ENV PATH=$PATH:$SPARK_HOME/bin
##SPARK VARIABLES END

## Set environment variable
##HADOOP VARIABLES START
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop-2.7.3
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV PATH=$PATH:$HADOOP_HOME/sbin
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
##HADOOP VARIABLES END

## Carpeta de datos temporales
RUN mkdir -p /app/hadoop/tmp 
##RUN chown hduser:hadoop /app/hadoop/tmp

RUN mkdir -p /opt/hadoop-2.7.3/hadoop_store/hdfs/namenode
RUN mkdir -p /opt/hadoop-2.7.3/hadoop_store/hdfs/datanode
##RUN chown -R hduser:hadoop /opt/hadoop-2.7.3/hadoop_store

# COPY ./CONFIG
COPY config/* /root/config/

# COPY ./vol-master
#COPY vol-master/* /root/vol-master/

# Edit hadoop files
RUN mv /root/config/ssh_config ~/.ssh/config 
RUN mv /root/config/core-site.xml /opt/hadoop-2.7.3/etc/hadoop/core-site.xml
RUN mv /root/config/hadoop-env.sh /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh  
RUN mv /root/config/hdfs-site.xml /opt/hadoop-2.7.3/etc/hadoop/hdfs-site.xml  
RUN mv /root/config/mapred-site.xml /opt/hadoop-2.7.3/etc/hadoop/mapred-site.xml 
RUN mv /root/config/masters /opt/hadoop-2.7.3/etc/hadoop/masters 
RUN mv /root/config/slaves-hadoop /opt/hadoop-2.7.3/etc/hadoop/slaves
RUN mv /root/config/yarn-site.xml /opt/hadoop-2.7.3/etc/hadoop/yarn-site.xml

# Move scripts start and stop
RUN mv /root/config/start-hadoop.sh ~/start-hadoop.sh 
RUN mv /root/config/stop-only-hadoop.sh ~/stop-only-hadoop.sh
RUN mv /root/config/stop-only-spark.sh ~/stop-only-spark.sh 
RUN mv /root/config/stop-all.sh ~/stop-all.sh 
RUN mv /root/config/clean-hdfs.sh ~/clean-hdfs.sh 
RUN mv /root/config/run-wordcount_hadoop.sh ~/run-wordcount_hadoop.sh
RUN mv /root/config/resize-cluster-gpu.sh ~/resize-cluster-gpu.sh

# Edit spark files
RUN mv /root/config/spark-env.sh $SPARK_HOME/conf/spark-env.sh
RUN mv /root/config/slaves-spark $SPARK_HOME/conf/slaves
RUN mv /root/config/start-spark.sh ~/start-spark.sh 

# Permisos internor
RUN chmod +x $SPARK_HOME/sbin/start-all.sh 
RUN chmod +x $HADOOP_HOME/sbin/start-dfs.sh 
RUN chmod +x $HADOOP_HOME/sbin/start-yarn.sh 
RUN chmod +x /root/config/generate-master-slaves.sh 
RUN chmod 600 ~/.ssh/config

# Permisos externos
RUN chmod +x ~/start-hadoop.sh 
RUN chmod +x ~/stop-only-hadoop.sh 
RUN chmod +x ~/stop-only-spark.sh 
RUN chmod +x ~/stop-all.sh 
RUN chmod +x ~/run-wordcount_hadoop.sh 
RUN chmod +x ~/clean-hdfs.sh 

#RUN cd ~/config/scalaDataGenerator 
#RUN sbt package

RUN cd ~ && \
    sbt package

## format namenode
#RUN hdfs namenode -format ##only hadoop
#
CMD [ "sh", "-c", "service ssh start; bash"]