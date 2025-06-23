#!/bin/bash
topic=$1
/opt/kafka/bin/kafka-console-consumer.sh \
  --topic "$topic" \
  --from-beginning \
  --bootstrap-server kafka:29092
