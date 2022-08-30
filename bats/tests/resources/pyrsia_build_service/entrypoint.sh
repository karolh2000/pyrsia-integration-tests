#!/bin/bash

# start build system
cd /src/pyrsia_build_pipeline_prototype
PATH="$HOME/.cargo/bin:$PATH" RUST_LOG=debug cargo run &

# start pyrsia node
chmod +x /src/pyrsia/target/debug/pyrsia_node
BOOTADDR=$(curl -s http://boot.pyrsia.link/status | jq -r ".peer_addrs[0]")
#/src/pyrsia/target/debug/pyrsia_node $* -P $BOOTADDR --host 0.0.0.0 --listen /ip4/0.0.0.0/tcp/44000 --pipeline-service-endpoint http://localhost:8080 --listen-only true
/src/pyrsia/target/debug/pyrsia_node --host 0.0.0.0 --listen /ip4/0.0.0.0/tcp/44000 --pipeline-service-endpoint http://localhost:8080 --listen-only true