#!/bin/bash

if [[ -z "${TRACKING_TOPICS}" ]] || [[ -z "${KAFKA_ZOOKEEPER_CONNECT}" ]] ; then
    echo "ERROR! This script cannot run standalone. TRACKING_TOPICS and KAFKA_ZOOKEEPER_CONNECT must be set."
    if [[ -z "${TRACKING_TOPICS}" ]] ; then
        echo "missing \${TRACKING_TOPICS}"
    fi
    if [[ -z "${KAFKA_ZOOKEEPER_CONNECT}" ]] ; then
        echo "missing \${KAFKA_ZOOKEEPER_CONNECT}"
    fi
    exit -1
fi

echo Waiting for Kafka to be ready...
cub kafka-ready -b "${BOOTSTRAP_SERVERS}" 1 20 > /dev/null 2>&1
RETVAL="$?"

if [[ "${RETVAL}" -ne 0 ]] ; then
    echo "ERROR: Couldn't connect to Kafka broker/s!"
    exit ${RETVAL}
fi

for topic in ${TRACKING_TOPICS//,/ } ; do
    echo "Creating topic \"$topic\"..."
    kafka-topics --zookeeper ${KAFKA_ZOOKEEPER_CONNECT} --create --if-not-exists --partitions 10 --replication-factor 2 --config cleanup.policy=delete --topic ${topic}
    if [[ "$?" -ne 0 ]] ; then
        echo "[WARNING] Unable to create topic \"${topic}"
    fi
done
