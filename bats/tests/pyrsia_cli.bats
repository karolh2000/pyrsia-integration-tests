#!/usr/bin/env bash

COMMON_SETUP='common-setup'
DOCKER_COMPOSE_DIR="$(pwd)/tests/resources/docker/docker-compose_bootstrap.yml"

setup_file() {
  load $COMMON_SETUP
  _common_setup_file "$DOCKER_COMPOSE_DIR"
}

teardown_file() {
  load $COMMON_SETUP
  _common_teardown_file
}

setup() {
    load $COMMON_SETUP
    _common_setup
}

@test "Testing pyrsia HELP, check if the help is shown." {
  # run pyrsia help
  run "$PYRSIA_TARGET_DIR"/pyrsia help
  # check if pyrsia help is shown
  assert_output --partial 'USAGE:'
  assert_output --partial 'OPTIONS:'
  assert_output --partial 'SUBCOMMANDS:'
}

@test "Testing pyrsia PING, check if the node is up and reachable." {
  # run pyrsia ping
  run "$PYRSIA_TARGET_DIR"/pyrsia ping
  # check if pyrsia ping returns errors
  refute_output --partial 'Error'
}

@test "Testing pyrsia STATUS, check if the node is connected to peers." {
  # run pyrsia status
  run "$PYRSIA_TARGET_DIR"/pyrsia status
  # check if pyrsia node has peers, fail if doesn't or error
  refute_output --partial '0'
  refute_output --partial 'Error'
}

@test "Testing 'pyrsia LIST' CLI, check if the node returns list of peers." {
  skip
  BATS_TEST_TIMEOUT=60
  # skip #skip this test since it's broken
  # run pyrsia list
  run "$PYRSIA_TARGET_DIR"/pyrsia list
  # Fail if the list is empty or error
  refute_output --partial '[]'
  refute_output --partial 'Error'
  unset BATS_TEST_TIMEOUT
}

@test 'Pyrsia CLI CONFIG EDIT, show the config and check the values' {
  run "$PYRSIA_TARGET_DIR"/pyrsia config --show
  #echo "$output" >&3
  assert_output --partial 'localhost'
  assert_output --partial '7888'
}
