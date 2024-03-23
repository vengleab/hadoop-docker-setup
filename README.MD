# This repo is just from self learning

## Command :
```bash
docker network create --driver=bridge --subnet 192.168.100.24 net1
```

## Start Container
```bash
docker run --name namenode -h namenode --net net1 --ip 192.168.100.2 -p 9870:9870 -p 8088:8088 -p 8888:8888 -p 10002:10002  -itd vengleab/hadoop-spark-hive:arm-v1
```

## Test spark
```bash
spark-submit --master yarn --class org.apache.spark.examples.JavaWordCount $SPARK_HOME/examples/jars/spark-examples_2.12-3.5.0.jar hdfs://namenode:9000/user/hadoop/words.txt hdfs://namenode:9000/user/hadoop/wordcount-out
```


# Self Notes

```bash
apt-get update && \
  apt-get install -y openjdk-8-jdk openssh-server python3-pip

cp -r /data/hadoop/hadoop-3.3.1 /usr/local/hadoop

export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
export PATH=$PATH:$JAVA_HOME/bin


cp /data/config/core-site.xml $HADOOP_HOME/etc/hadoop/
cp /data/config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/
cp /data/config/mapred-site.xml $HADOOP_HOME/etc/hadoop/
cp /data/config/yarn-site.xml $HADOOP_HOME/etc/hadoop/
cp /data/config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/
```


nano /usr/local/hadoop/etc/hadoop/hadoop-env.sh 

```bash
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
```



service ssh start

ssh-keygen -t rsa -P ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


# Spark Configuration

## Copy Spark folder
```bash
cp -r spark-3.5.0-bin-hadoop3/ /usr/local/spark
```

```bash
export SPARK_HOME=/usr/local/spark
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export SPARK_LOCAL_IP=127.0.0.1
```

## Edit config

```bash
cd $SPARK_HOME/conf
cp spark-defaults.conf.template spark-defaults.conf
nano spark-defaults.conf
```

**Add content below**
```env
spark.master yarn
spark.eventLog.enabled true
spark.eventLog.dir hdfs://namenode:9000/spark-logs
spark.history.provider org.apache.spark.deploy.history.FsHistoryProvider
spark.history.fs.logDirectory hdfs://namenode:9000/spark-logs
```
