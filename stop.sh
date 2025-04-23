#!/usr/bin/env bash

# call sh file to set env variables
source ./env.sh

# stop broker
$KAFKA_BIN_DIR/kafka-server-stop.sh --config-file broker.1.sasl.plain.properties && sleep 5
# stop controller
$KAFKA_BIN_DIR/kafka-server-stop.sh --config-file controller.1.properties

# stop broker,controller processes
pkill -f Kafka

# cleanup folders
rm -fr ./1/kraft-metadata-dir/*
rm -fr /tmp/kraft-controller-logs/1/*