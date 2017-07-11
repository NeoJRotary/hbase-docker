#!/bin/bash

# start hadoop
/hadoop.sh

if [ "$MODE" == "ENV" ]; then
  IFS=',' read -ra hostList <<< "$HOSTS"
  region=""
  for h in "${hostList[@]}"; do
    region=$region$h$'\n'
  done
  echo "$region" > $HBASE_CONF_DIR/regionservers
else
  cat /hosts > /etc/hosts
  IFS='\n' read -ra hostList <<< "$( < "$HADOOP_CONF_DIR"/slaves)"
  HOSTS=""
  for h in "${hostList[@]}"; do
    HOSTS="$HOSTS,$h"
  done
fi

zoo=""
num=1
for h in "${hostList[@]}"; do
  zoo=$zoo"server.$num=$h:2888:3888"$'\n'
  num=$((num+1))
done
echo "$zoo" >> $ZOOCFGDIR/zoo.cfg

sed -i 's/NAMENODE/'"${hostList[0]}"'/g' $HBASE_CONF_DIR/hbase-site.xml
sed -i 's/HOSTLIST/'"$HOSTS"'/g' $HBASE_CONF_DIR/hbase-site.xml

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
  echo $MYID > /data/zookeeper/myid
fi
rm -rf /zookeeper/logs/*
$ZOOKEEPER_HOME/bin/zkServer.sh start

# start hbase
if [[ $ROLE == "namenode" ]]; then
  sleep 3s
  $HBASE_HOME/bin/start-hbase.sh

  # start rest api
  sleep 3s
  $HBASE_HOME/bin/hbase-daemon.sh start rest
fi

if [ "$1" == "-bash" ]
then
  bash
elif [ "$1" == "-sleep" ]
then
  while true
  do
	  sleep 24h
  done
fi