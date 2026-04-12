#!/bin/bash

KAFKA_BROKER="kafka:29092"

echo "⏳ Waiting for Kafka to be ready at $KAFKA_BROKER..."
cub kafka-ready -b $KAFKA_BROKER 1 60

echo "🚀 Starting topic creation..."

topics=(
  "customer-created"
  "customer-profile-updated"
  "customer-address-updated"
  "customer-status-updated"
  "insurance-policy-created"
  "insurance-policy-updated"
  "insurance-policy-cancelled"
)

for topic in "${topics[@]}"; do
  kafka-topics --create --if-not-exists \
    --bootstrap-server $KAFKA_BROKER \
    --partitions 3 \
    --replication-factor 1 \
    --topic "$topic"

  if [ $? -eq 0 ]; then
    echo "✅ Topic '$topic' created successfully (or already exists)."
  else
    echo "❌ Failed to create topic '$topic'."
  fi
done

echo "🏁 Kafka setup completed!"