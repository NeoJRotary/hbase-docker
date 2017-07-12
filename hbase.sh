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
  IFS=' ' read -ra hostList <<< $(<$HBASE_CONF_DIR/regionservers)
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

if [ "$DNSNAMESERVER" != "" ]; then
  sed -i 's/DNSNAMESERVER/'"$DNSNAMESERVER"'/g' $HBASE_CONF_DIR/hbase-site.xml
else 
  sed -i 's/DNSNAMESERVER/default/g' $HBASE_CONF_DIR/hbase-site.xml
fi

if [ "$REGIONSERVER_HOSTNAME" != "" ]; then
  sed -i 's/REGIONSERVER_HOSTNAME/'"$REGIONSERVER_HOSTNAME"'/g' $HBASE_CONF_DIR/hbase-site.xml
else 
  sed -i 's/REGIONSERVER_HOSTNAME//g' $HBASE_CONF_DIR/hbase-site.xml
fi

if [ "$REGIONSERVER_REVERSE_DISABLE" != "" ]; then
  sed -i 's/REGIONSERVER_REVERSE_DISABLE/'"$REGIONSERVER_REVERSE_DISABLE"'/g' $HBASE_CONF_DIR/hbase-site.xml
else 
  sed -i 's/REGIONSERVER_REVERSE_DISABLE/false/g' $HBASE_CONF_DIR/hbase-site.xml
fi

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