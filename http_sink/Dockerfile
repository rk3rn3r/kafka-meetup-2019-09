ARG APP_CONFLUENT_PLATFORM_VERSION
FROM confluentinc/cp-kafka-connect-base:${APP_CONFLUENT_PLATFORM_VERSION}

RUN echo "===> Installing Kafka Connect HTTP Sink Connector ..." && \
confluent-hub install confluentinc/kafka-connect-http:1.0.2 --no-prompt
