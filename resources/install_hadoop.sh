#!/bin/sh

# Hadoop Ver Vars
HADOOP_VER="hadoop-3.2.1"
HADOOP_URL="https://www-us.apache.org/dist/hadoop/common/$HADOOP_VER/$HADOOP_VER.tar.gz"
HADOOP_CHECKSUM="https://www-us.apache.org/dist/hadoop/common/$HADOOP_VER/$HADOOP_VER.tar.gz.mds"

# Download core Hadoop to ~
cd
wget $HADOOP_URL

# Download checksum
wget $HADOOP_CHECKSUM

# Validate Checksum
# TODO - write validation logic
shasum -a 256 $HADOOP_VER.tar.gz
cat $HADOOP_VER.tar.gz.mds

# Extract core Hadoop logic
sudo tar -zxvf $HADOOP_VER.tar.gz -C /opt

# Make vagrant user the owner of hadoop logic
sudo chown -R $USER /opt/$HADOOP_VER

# Hadoop core config edit
JAVA_ENV=$(readlink -f /usr/bin/java | sed "s:bin/java::")
echo "export JAVA_HOME=$JAVA_ENV" | sudo tee -a /opt/$HADOOP_VER/etc/hadoop/hadoop-env.sh

# Add hadoop to path & sys profile
echo "export PATH=/opt/$HADOOP_VER/bin:$PATH" | sudo tee -a /etc/profile
source /etc/profile

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
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOF