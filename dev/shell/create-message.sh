#!/bin/bash
topic=$1
/opt/kafka/bin/kafka-console-producer.sh \
  --topic "$topic" \
  --bootstrap-server kafka:29092
