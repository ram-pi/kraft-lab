# kraft lab

## References 

- [KIP-500](https://cwiki.apache.org/confluence/display/KAFKA/KIP-500%3A+Replace+ZooKeeper+with+a+Self-Managed+Metadata+Quorum)
- [KIP-595](https://cwiki.apache.org/confluence/display/KAFKA/KIP-595%3A+A+Raft+Protocol+for+the+Metadata+Quorum)
- [KIP-630](https://cwiki.apache.org/confluence/display/KAFKA/KIP-630%3A+Kafka+Raft+Snapshot)

## Current version

```
KAFKA_VERSION=4.0.0
```


## Start 

Using the `./start.sh` it will start one kraft controller and a broker (observer).

## Debug

List of commands you can practice with.

```
KAFKA_VERSION=4.0.0
KAFKA_DIR=$(pwd)
KAFKA_BIN_DIR=$KAFKA_DIR/kafka_2.13-$KAFKA_VERSION/bin

# older versions
#$KAFKA_BIN_DIR/kafka-metadata-shell.sh --directory ./1/kraft-metadata-dir/__cluster_metadata-0/
$KAFKA_BIN_DIR/kafka-metadata-shell.sh --snapshot ./1/kraft-metadata-dir/__cluster_metadata-0/leader-epoch-checkpoint
$KAFKA_BIN_DIR/kafka-metadata-quorum.sh --command-config client.properties --bootstrap-server localhost:9092 describe --status
$KAFKA_BIN_DIR/kafka-metadata-quorum.sh --command-config client.properties --bootstrap-server localhost:9092 describe --replication
$KAFKA_BIN_DIR/kafka-dump-log.sh --cluster-metadata-decoder --files 1/kraft-metadata-dir/__cluster_metadata-0/00000000000000000000.log

```

## Stop

Run the `./stop.sh` script.

