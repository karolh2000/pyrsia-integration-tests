#!/bin/bash

# update the build service (prototype)
echo "Updating the build service..."
BUILD_SERVICE_DIR=/src/pyrsia_build_pipeline_prototype
git --git-dir="$BUILD_SERVICE_DIR"/.git fetch
git --git-dir="$BUILD_SERVICE_DIR"/.git --work-tree="$BUILD_SERVICE_DIR" merge origin/main