#!/bin/bash

HOST=$(hostname)

if [[ "$HOST" == *"metastore"* ]]; then

  # Create Hive directories
  hdfs dfs -mkdir -p /user/hive/warehouse
  hdfs dfs -mkdir -p /tmp

  # Set permissions
  hdfs dfs -chmod g+wx /user
  hdfs dfs -chmod g+wx /tmp

  # Set up Tez libraries
  hdfs dfs -mkdir -p /apps/tez
  hdfs dfs -chmod g+wx /apps/tez
  hdfs dfs -put /usr/local/tez/share/tez.tar.gz /apps/tez

  # if [[ $(psql -U hive -d hivemetastore -tAc "SELECT 1 FROM pg_database WHERE datname='hivemetastore';") != "1" ]]; then
    schematool -dbType postgres -initSchema
  # fi

  # Start Hive Metastore
  hive --service metastore
fi
sleep 60
if [[ "$HOST" == *"server"* ]]; then
    hiveserver2
fi
