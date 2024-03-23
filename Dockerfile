# Base image
FROM ubuntu:18.04

# Install Java
RUN apt-get update && \
  apt-get install -y openjdk-8-jdk openssh-server python3-pip

# Install Hadoop
COPY data/hadoop/hadoop-3.3.1 /usr/local/hadoop

# Set Hadoop environment variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Copy Hadoop configuration files
COPY data/config/core-site.xml $HADOOP_HOME/etc/hadoop/
COPY data/config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY data/config/mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY data/config/yarn-site.xml $HADOOP_HOME/etc/hadoop/
COPY data/config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/

# Set Java environment variables
# ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
ENV PATH=$PATH:$JAVA_HOME/bin

# Format the Hadoop file system
RUN hdfs namenode -format

ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

# Setup SSH server
RUN ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Expose Hadoop ports
EXPOSE 8088 9870 22

# Start Hadoop
CMD service ssh start && start-all.sh && bash
