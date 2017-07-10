#!/bin/bash
##################################################
##  Curl Script to demonstrate using the kafka rest
##    client to add a topic, and a connectors to use the
##    kafka sink to write to Couchbase
##################################################

## List Topics
curl -X GET "http://localhost:8082/topics"

curl -X GET "http://localhost:8083/connectors/"

### AVRO Send a full document specifying the key
curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"key_schema": "{\"name\":\"user_id\"  ,\"type\": \"int\"   }", "value_schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}", "records": [{"key" : 1 , "value": {"name": "testUser"}}]}' \
      "http://localhost:8082/topics/bar"

## Create Connector
curl -X POST -H "Content-Type: application/json" \
     --data '{"name": "cb", "config": {"connector.class":"com.couchbase.connect.kafka.CouchbaseSinkConnector","tasks.max":"1", "topics":"bar","connection.cluster_address":"cbdb","connection.bucket":"receiver"}}' \
    "http://localhost:8083/connectors"

## Delete Connector
## curl -X DELETE localhost:8083/connectors/
