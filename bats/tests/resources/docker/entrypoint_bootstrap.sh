#!/bin/bash

apt-get update && apt-get install -y

# update and build pyrsia sources
PYRSIA_DIR=/src/pyrsia
git --git-dir=$PYRSIA_DIR/.git fetch
git --git-dir=$PYRSIA_DIR/.git --work-tree=$PYRSIA_DIR merge origin/main
cargo build --package=pyrsia_node --manifest-path=$PYRSIA_DIR/Cargo.toml

# start pyrsia node (bootstrap no build service)
chmod +x $PYRSIA_DIR/target/debug/pyrsia_node
BOOTADDR=$(curl -s http://boot.pyrsia.link/status | jq -r ".peer_addrs[0]")
$PYRSIA_DIR/target/debug/pyrsia_node $* -P "$BOOTADDR" --host 0.0.0.0 --listen /ip4/0.0.0.0/tcp/44000