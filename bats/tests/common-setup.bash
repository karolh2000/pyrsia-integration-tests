#!/usr/bin/env bash

# the tests temp dir
PYRSIA_TEMP_DIR=/tmp/pyrsia_tests/pyrsia
# the pyrsia binaries
PYRSIA_TARGET_DIR=$PYRSIA_TEMP_DIR/target/release
# if "true" then the temp files (pyrsia sources, binaries, etc.) and the docker images/containers are destroyed in "teardown_file" method. 
#CLEAN_UP_TEST_ENVIROMENT=false

_common_setup() {
  # load the bats "extenstions"
  load '../lib/test_helper/bats-support/load'
  load '../lib/test_helper/bats-assert/load'
}

#
_common_setup_file() {
  echo "Setting up the tests environment..." >&3
  local git_branch="karolh2000/integ_tests_bats"
  # clone or update the sources
  if [ -d $PYRSIA_TEMP_DIR/.git ]; then
    git --git-dir=$PYRSIA_TEMP_DIR/.git fetch
    git --git-dir=$PYRSIA_TEMP_DIR/.git --work-tree=$PYRSIA_TEMP_DIR merge origin/main
  else
    mkdir -p $PYRSIA_TEMP_DIR
    git clone --branch $git_branch https://github.com/karolh2000/pyrsia.git $PYRSIA_TEMP_DIR
  fi

  echo "Building the Pyrsia sources, it might take a while..." >&3
  cargo build --profile=release --package=pyrsia_cli --manifest-path=$PYRSIA_TEMP_DIR/Cargo.toml
  echo "Building Pyrsia completed!" >&3
  echo "Building the node docker image and starting the container, it might take a while..." >&3
  #docker-compose -f $PYRSIA_TEMP_DIR/docker-compose.yml up -d
  docker-compose -f $1/docker-compose.yml up -d
  sleep 10
  echo "Node docker container is up!" >&3
  echo "The tests environment is ready!" >&3
  echo "Running tests..." >&3
}

_common_teardown_file() {
  echo "" >&3
  # when
  if [ $CLEAN_UP_TEST_ENVIROMENT = true ]; then
    echo "Tearing down the tests environment..." >&3
    echo "Cleaning up the docker images and containers..."  >&3
    docker-compose -f /tmp/pyrsia/docker-compose.yml down --rmi all
    echo "Removing the temp files ($PYRSIA_TEMP_DIR)..."  >&3
    rm -rf "$PYRSIA_TEMP_DIR"
  else
    echo "Stopping the docker containters (containers and images not removed)" >&3
    docker-compose -f /tmp/pyrsia/docker-compose.yml stop >&3
    echo "The test temp files not removed!"  >&3
    echo "The docker images/containers and temp dir wad not removed because 'CLEAN_UP_TEST_ENVIROMENT = $CLEAN_UP_TEST_ENVIROMENT'"  >&3
  fi
  echo "Done tearing the tests environment!" >&3
}