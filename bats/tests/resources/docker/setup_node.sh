#!/bin/bash

echo "Updating the OS and Pyrsia node sources..."
apt-get update && apt-get install -y

# update and build pyrsia sources
PYRSIA_DIR=/src/pyrsia
git --git-dir="$PYRSIA_DIR"/.git fetch
git --git-dir="$PYRSIA_DIR"/.git --work-tree="$PYRSIA_DIR" merge origin/main
cargo build --package=pyrsia_node --manifest-path="$PYRSIA_DIR"/Cargo.toml
chmod +x "$PYRSIA_DIR"/target/debug/pyrsia_node