#!/bin/bash

# setup node
PYRSIA_DIR=/src/pyrsia
/src/setup_node.sh
# start node (bootstrap)
echo "Start Pyrsia node..."
BOOTADDR=$(curl -s http://boot.pyrsia.link/status | jq -r ".peer_addrs[0]")
$PYRSIA_DIR/target/debug/pyrsia_node $* -P "$BOOTADDR" --host 0.0.0.0 --listen /ip4/0.0.0.0/tcp/44000