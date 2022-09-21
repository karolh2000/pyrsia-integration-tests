#!/usr/bin/env bash

# check if docker is running/installed.
if (! docker stats --no-stream ); then
  echo "Docker not found, please make sure Docker is installed and running!"
  exit 1
fi

# identify repo path
if [ -n "$REPO_DIR" ]; then
  echo "Repo path REPO_DIR=$REPO_DIR"
else
    echo "The REPO_DIR variable is not specified, Please provide the integration tests repository path (e.g. '$HOME/pyrsia-integration-tests')."
    exit 1
fi
# export repo path (used in the tests)
export REPO_DIR;

# start the tests
echo "Starting Pyrsia integration tests in $REPO_DIR..."
$REPO_DIR/bats/lib/bats/bin/bats "$REPO_DIR/bats/tests"
