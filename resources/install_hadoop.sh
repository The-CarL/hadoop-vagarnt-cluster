#!/bin/sh

# Hadoop Ver Vars
HADOOP_VER="hadoop-3.2.1"
HADOOP_URL="https://www-us.apache.org/dist/hadoop/common/$HADOOP_VER/$HADOOP_VER.tar.gz"
HADOOP_CHECKSUM="https://www-us.apache.org/dist/hadoop/common/$HADOOP_VER/$HADOOP_VER.tar.gz.mds"

# Download core Hadoop to ~
cd
wget $HADOOP_URL > /dev/null 2>errors.txt
cat errors.txt

# Download checksum
wget $HADOOP_CHECKSUM > /dev/null 2>errors.txt
cat errors.txt

# Validate Checksum
# TODO - write validation logic
shasum -a 256 $HADOOP_VER.tar.gz
cat $HADOOP_VER.tar.gz.mds

# Extract core Hadoop logic
sudo tar -zxvf $HADOOP_VER.tar.gz -C /opt > /dev/null 2>errors.txt
cat errors.txt

# Make vagrant user the owner of hadoop logic
sudo chown -R $USER /opt/$HADOOP_VER > /dev/null 2>errors.txt
cat errors.txt

# Hadoop core config edit
JAVA_ENV=$(readlink -f /usr/bin/java | sed "s:bin/java::")
echo "export JAVA_HOME=$JAVA_ENV" | sudo tee -a /opt/$HADOOP_VER/etc/hadoop/hadoop-env.sh

# Add user to hadoop config
echo "export HDFS_NAMENODE_USER=\"$USER\"" | sudo tee -a /opt/$HADOOP_VER/etc/hadoop/hadoop-env.sh
echo "export HDFS_DATANODE_USER=\"$USER\"" | sudo tee -a /opt/$HADOOP_VER/etc/hadoop/hadoop-env.sh
echo "export HDFS_SECONDARYNAMENODE_USER=\"$USER\"" | sudo tee -a /opt/$HADOOP_VER/etc/hadoop/hadoop-env.sh
echo "export YARN_RESOURCEMANAGER_USER=\"$USER\"" | sudo tee -a /opt/$HADOOP_VER/etc/hadoop/hadoop-env.sh
echo "export YARN_NODEMANAGER_USER=\"$USER\"" | sudo tee -a /opt/$HADOOP_VER/etc/hadoop/hadoop-env.sh

# Add hadoop to path & sys profile
echo "export PATH=/opt/$HADOOP_VER/bin:$PATH" | sudo tee -a /etc/profile
source /etc/profile #TODO - add this to every login

# HDFS setup... https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html
tee /opt/$HADOOP_VER/etc/hadoop/core-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOF

tee /opt/$HADOOP_VER/etc/hadoop/hdfs-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
    <name>dfs.permissions.enabled</name>
    <value>false</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
  <name>dfs.webhdfs.enabled</name>
  <value>true</value>
  <description>
         Enable REST access to HDFS without additional security in kerberos.
  </description>
</property>
<property>
  <name>dfs.namenode.rpc-bind-host</name>
  <value>0.0.0.0</value>
  <description>
         The actual address the RPC server will bind to. If this optional address is
         set, it overrides only the hostname portion of dfs.namenode.rpc-address.
         It can also be specified per name node or name service for HA/Federation.
         This is useful for making the name node listen on all interfaces by
         setting it to 0.0.0.0.
  </description>
</property>

<property>
  <name>dfs.namenode.servicerpc-bind-host</name>
  <value>0.0.0.0</value>
  <description>
         The actual address the service RPC server will bind to. If this optional address is
         set, it overrides only the hostname portion of dfs.namenode.servicerpc-address.
         It can also be specified per name node or name service for HA/Federation.
         This is useful for making the name node listen on all interfaces by
         setting it to 0.0.0.0.
  </description>
</property>

<property>
  <name>dfs.namenode.http-bind-host</name>
  <value>0.0.0.0</value>
  <description>
         The actual address the HTTP server will bind to. If this optional address
         is set, it overrides only the hostname portion of dfs.namenode.http-address.
         It can also be specified per name node or name service for HA/Federation.
         This is useful for making the name node HTTP server listen on all
         interfaces by setting it to 0.0.0.0.
  </description>
</property>

<property>
  <name>dfs.namenode.https-bind-host</name>
  <value>0.0.0.0</value>
  <description>
         The actual address the HTTPS server will bind to. If this optional address
         is set, it overrides only the hostname portion of dfs.namenode.https-address.
         It can also be specified per name node or name service for HA/Federation.
         This is useful for making the name node HTTPS server listen on all
         interfaces by setting it to 0.0.0.0.
  </description>
</property>
</configuration>
EOF

# Initial HDFS format
hdfs namenode -format > /dev/null 2>errors.txt
cat errors.txt

# Start Hadoop Namenode and HDFS datanodes
/opt/$HADOOP_VER/sbin/start-all.sh > /dev/null 2>errors.txt
cat errors.txt

hdfs dfs -mkdir -p /user/$USER > /dev/null 2>errors.txt
cat errors.txt

hdfs dfs -mkdir -p /tmp > /dev/null 2>errors.txt
cat errors.txt

hdfs dfs -mkdir -p /user/root/movies > /dev/null 2>errors.txt
cat errors.txt

hdfs dfs -mkdir -p /user/root/test > /dev/null 2>errors.txt
cat errors.txt

cat <<EOF > test.csv
id_1,id_2,id_3
1,2,3
4,5,6
7,8,9
EOF

hdfs dfs -put test.csv /user/root/test
rm -f test.csv

DATA_FILES=/tmp/file-drop/*
for f in $DATA_FILES; do
    hdfs dfs -put $f /user/root/movies > /dev/null 2>errors.txt
    cat errors.txt
done