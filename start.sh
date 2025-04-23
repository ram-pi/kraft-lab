#!/usr/bin/env bash

# call sh file to set env variables
source ./env.sh
echo "Using Kafka Version: $KAFKA_VERSION"

# check if kafka binaries are in this directory, if not download kafka 4.0.0 from https://dlcdn.apache.org/kafka/4.0.0/kafka_2.13-4.0.0.tgz and extract it here
if [ ! -d "kafka_2.13-$KAFKA_VERSION" ]; then
    echo "Kafka binaries not found in this directory. Please download Kafka $KAFKA_VERSION from https://dlcdn.apache.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz and extract it here."
    # download kafka 4.0.0 from https://dlcdn.apache.org/kafka/4.0.0/kafka_2.13-4.0.0.tgz
    wget https://dlcdn.apache.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz
    # extract kafka 4.0.0
    tar -xzf kafka_2.13-$KAFKA_VERSION.tgz
    rm -f kafka_2.13-$KAFKA_VERSION.tgz
fi

# stop broker,controller processes
pkill -f Kafka

# cleanup folders
rm -fr ./1/kraft-metadata-dir/*
rm -fr /tmp/kraft-controller-logs/1/*
rm -fr /tmp/kraft-broker-logs/1/*

# generate random-uuid with kafka-storage random-uuid and put in kafka-uuid variable
KAFKA_UUID=$(kafka-storage random-uuid)
echo "Generated Kafka UUID: $KAFKA_UUID"

# format storage with kafka-storage format
$KAFKA_BIN_DIR/kafka-storage.sh format -t $KAFKA_UUID -c controller.1.properties
$KAFKA_BIN_DIR/kafka-storage.sh format -t $KAFKA_UUID -c broker.1.properties

# enable jmx
#export JAVA_OPTS="-Dcom.sun.management.jmxremote.host=0.0.0.0 -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 Dcom.sun.management.jmxremote.authenticate=false"
#export JMX_PORT=9010
#export JMX_HOST=localhost

# start kraft controllers 
$KAFKA_BIN_DIR/kafka-server-start.sh controller.1.properties &> controller.1.log &

# start kafka broker
$KAFKA_BIN_DIR/kafka-server-start.sh broker.1.sasl.plain.properties &> broker.1.log &
#kafka-server-start broker.1.properties &> broker.1.log &

# echo "Read cluster metadata with the following command: kafka-metadata-shell --directory tmp/kraft-controller-logs/_cluster-metadata-0/
echo "Read cluster metadata with the following command: kafka-metadata-shell --directory ./1/kraft-metadata-dir/__cluster_metadata-0/"

# debug kraft with "kafka-metadata-quorum --command-config client.properties --bootstrap-server localhost:9092 describe --status"
echo "Debug kraft with 'kafka-metadata-quorum --command-config client.properties --bootstrap-server localhost:9092 describe --status'"
echo "Debug kraft with 'kafka-metadata-quorum --command-config client.properties --bootstrap-server localhost:9092 describe --replication'"

# read log segments with " kafka-dump-log --cluster-metadata-decoder --files 1/kraft-metadata-dir/__cluster_metadata-0/00000000000000000000.log"
echo "Read log segments with 'kafka-dump-log --cluster-metadata-decoder --files 1/kraft-metadata-dir/__cluster_metadata-0/00000000000000000000.log'"
