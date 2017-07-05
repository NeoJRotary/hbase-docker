#!/bin/bash

# start hadoop
/hadoop.sh
sleep 3s

if [ -d "/hbase/logs" ]
then
  rm -rf /hbase/logs/*
fi
if [ -d "/zookeeper/logs" ]
then
  rm -rf /hbase/logs/*
fi

# start zookeeper
if [ ! -d "/data/zookeeper" ]
then
  mkdir -p /data/zookeeper /zookeeper/logs
  touch /data/zookeeper/myid
  echo $ZK_MYID > /data/zookeeper/myid
fi
rm -rf /zookeeper/logs/*
$ZOOKEEPER_HOME/bin/zkServer.sh start

# start hbase
if [[ $HOSTNAME == "master" ]]; then
  sleep 3s
  $HBASE_HOME/bin/start-hbase.sh

  # start rest api
  sleep 3s
  $HBASE_HOME/bin/hbase-daemon.sh start rest
fi

if [ "$1" == "-bash" ]
then
  bash
fi
