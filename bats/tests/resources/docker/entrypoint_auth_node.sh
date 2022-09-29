#!/bin/bash

# start the build service
cd /src/pyrsia_build_pipeline_prototype || exit 1
RUST_LOG=debug cargo run &

# wait until the node service is ready (the node service is defined in pyrsia-integration-tests/bats/tests/resources/docker/docker-compose_auth_nodes.yml)
for i in {0..20}
do
  # get the peer id from the node service (defined in pyrsia-integration-tests/bats/tests/resources/docker/docker-compose_auth_nodes.yml)
  BOOTADDR=$(curl -s http://node:7888/status | jq -r ".peer_addrs[0]")
  if [[ "$BOOTADDR" == *"127"* ]]; then
    BOOTADDR=$(curl -s http://node:7888/status | jq -r ".peer_addrs[1]")
  fi
  if ([ ! -z "$BOOTADDR" ] && [ "$BOOTADDR" != "null" ]); then
    # the peer id obtained, don't wait anymore
    break
  fi
  # wait another 5 sec for the node service
  sleep 5
done

# terminate if the node peer id not found
if ([ -z "$BOOTADDR" ] || [ "$BOOTADDR" == "null" ]); then
  exit 1
fi

echo "/src/pyrsia/target/debug/pyrsia_node "$@" -P "$BOOTADDR" -p 7889 --host 0.0.0.0 --pipeline-service-endpoint http://localhost:8080 --listen /ip4/0.0.0.0/tcp/44001"

# start the authorize node with the node service peer id
RUST_LOG=pyrsia=debug /src/pyrsia/target/debug/pyrsia_node "$@" -P "$BOOTADDR" -p 7889 --host 0.0.0.0 --pipeline-service-endpoint http://localhost:8080 --listen /ip4/0.0.0.0/tcp/44001
