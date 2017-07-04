#!/bin/bash

echo "INIT HADOOP"
/hadoop.sh
echo "HADOOP IS READY"

echo "sleep 3s"
sleep 3s

echo "START ZOOKEEPER"
mkdir -p $ZOOKEEPER_HOME/data $ZOOKEEPER_HOME/logs
touch $ZOOKEEPER_HOME/data/myid
echo $ZK_MYID > $ZOOKEEPER_HOME/data/myid
$ZOOKEEPER_HOME/bin/zkServer.sh start
echo "ZOOKEEPER IS READY"

if [[ $HOSTNAME == "master" ]]; then
    echo "sleep 3s"
    sleep 3s

    echo "START HBASE"
    mkdir -p /hbase/tmp
    $HBASE_HOME/bin/start-hbase.sh
    echo "HBASE IS READY"
fi

bash
