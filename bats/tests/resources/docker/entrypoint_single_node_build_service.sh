#!/bin/bash

apt-get update && apt-get install -y

# update and start the build service (prototype)
BUILD_SERVICE_DIR=/src/pyrsia_build_pipeline_prototype
git --git-dir=$BUILD_SERVICE_DIR/.git fetch
git --git-dir=$BUILD_SERVICE_DIR/.git --work-tree=$BUILD_SERVICE_DIR merge origin/main
cargo run --manifest-path=$BUILD_SERVICE_DIR/Cargo.toml

# update the pyrsia nodes
PYRSIA_DIR=/src/pyrsia
git --git-dir=$PYRSIA_DIR/.git fetch
git --git-dir=$PYRSIA_DIR/.git --work-tree=$PYRSIA_DIR merge origin/main
cargo build --package=pyrsia_node --manifest-path=$PYRSIA_DIR/Cargo.toml

# start pyrsia node (bootstrap no build service)
chmod +x $PYRSIA_DIR/target/debug/pyrsia_node
RUST_LOG=pyrsia=debug $PYRSIA_DIR/target/debug/pyrsia_node --host 0.0.0.0 --pipeline-service-endpoint http://localhost:8080 --listen-only true