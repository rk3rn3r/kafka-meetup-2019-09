#!/usr/bin/env bash
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9990}, "value": {"type": "track", "uid":"user000001","event":"Tried out sending data using Kafka Batching","properties":{"reason":"Make the audience happy1!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9991}, "value": {"type": "track", "uid":"user000002","event":"Tried out sending data using Kafka Batching","properties":{"reason":"Make the audience happy2!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9992}, "value": {"type": "track", "uid":"user000003","event":"Tried out sending data using Kafka Batching","properties":{"reason":"Make the audience happy3!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9993}, "value": {"type": "track", "uid":"user000004","event":"Tried out sending data using Kafka Batching","properties":{"reason":"Make the audience happy4!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9994}, "value": {"type": "track", "uid":"user000005","event":"Tried out sending data using Kafka Batching","properties":{"reason":"Make the audience happy5!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9995}, "value": {"type": "track", "uid":"user000006","event":"Tried out sending data using Kafka Batching","properties":{"reason":"Make the audience happy6!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9996}, "value": {"type": "track", "uid":"user000007","event":"Tried out sending data using Kafka Batching","properties":{"reason":"Make the audience happy7!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9997}, "value": {"type": "track", "uid":"user000008","event":"Tried out sending data using Kafka Batching","properties":{"reason":"Make the audience happy8!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9009}, "value": {"type": "track", "uid":"user0002","event":"Sending data using Kafka Batching","properties":{"reason":"KAFKA rules!"}}}]}' "http://localhost:58082/topics/tracking" && \
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records": [{"key": {"userid": 9009}, "value": {"type": "track", "uid":"user0003","event":"Sending data using Kafka Batching","properties":{"reason":"KAFKA rules!"}}}]}' "http://localhost:58082/topics/tracking"