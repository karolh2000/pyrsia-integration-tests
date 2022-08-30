#!/usr/bin/env bash

COMMON_SETUP='common-setup'

setup_file() {
  load $COMMON_SETUP
  _common_setup_file "$(pwd)/tests/resources/pyrsia_build_service"
}

teardown_file() {
  load $COMMON_SETUP
  _common_teardown_file
}

setup() {
    load $COMMON_SETUP
    _common_setup
}

@test "Testing if the node and build service is up." {
  # run pyrsia ping
   run "$PYRSIA_TARGET_DIR"/pyrsia ping
   #echo "$output" >&3
   # check if pyrsia ping returns errors
   refute_output --partial 'Error'
}

@test "Testing if the node and build service is up." {
  # run pyrsia ping
   run "$PYRSIA_TARGET_DIR"/pyrsia ping
   #echo "$output" >&3
   # check if pyrsia ping returns errors
   refute_output --partial 'Error'
}

