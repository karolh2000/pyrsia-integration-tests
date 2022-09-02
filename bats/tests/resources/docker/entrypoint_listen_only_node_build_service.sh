#!/bin/bash

# setup build service and node
PYRSIA_DIR=/src/pyrsia
BUILD_SERVICE_DIR=/src/pyrsia_build_pipeline_prototype
/src/setup_node.sh
/src/setup_build_service.sh

# update and start the build service (prototype)
echo "Start Pyrsia build service..."
#cargo run --manifest-path=$BUILD_SERVICE_DIR/Cargo.toml &
cd $PYRSIA_DIR
RUST_LOG=debug cargo run &

# start pyrsia node (bootstrap no build service)
echo "Start Pyrsia node..."
RUST_LOG=pyrsia=debug $PYRSIA_DIR/target/debug/pyrsia_node --host 0.0.0.0 --listen /ip4/0.0.0.0/tcp/44000 --pipeline-service-endpoint http://localhost:8080 --listen-only true
