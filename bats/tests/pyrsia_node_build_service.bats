#!/usr/bin/env bash

# common setup
COMMON_SETUP='common-setup'
# docker compose file
DOCKER_COMPOSE_DIR="$(pwd)/tests/resources/docker/docker-compose_single_node.yml"
# maven build service mapping ID
BUILD_SERVICE_MAVEN_MAPPING_ID="commons-codec:commons-codec:1.15"

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
    PYRSIA_CLI="$PYRSIA_TARGET_DIR/pyrsia"
}

@test "Testing if the node and build service is up, ping." {
  # run pyrsia ping
   run "$PYRSIA_CLI" ping
   refute_output --partial 'Error'
}

@test "Testing the build service, maven (build, inspect-log)." {
  # run pyrsia node ping
  run "$PYRSIA_CLI" ping

  # the build request should fail on the non existing maven mapping ID
#  run "$PYRSIA_TARGET_DIR"/pyrsia build maven --gav FAKE_ID
#  refute_output --partial  "successfully"

  # confirm the artifact is not already added to pyrsia node
  run "$PYRSIA_CLI" inspect-log maven --gav $BUILD_SERVICE_MAVEN_MAPPING_ID
  refute_output --partial $BUILD_SERVICE_MAVEN_MAPPING_ID

  # init the build
  run "$PYRSIA_CLI" build maven --gav $BUILD_SERVICE_MAVEN_MAPPING_ID
  assert_output --partial "successfully"

  # waiting until the build is done => inspect logs available
  echo "A new build for $BUILD_SERVICE_MAVEN_MAPPING_ID triggered, waiting until is completed..." >&3
  for i in {0..15..1}
  do
    echo "Still waiting for $BUILD_SERVICE_MAVEN_MAPPING_ID..." >&3
    inspect_log=$($PYRSIA_CLI inspect-log maven --gav $BUILD_SERVICE_MAVEN_MAPPING_ID)
    if [[ "$inspect_log" == *"$BUILD_SERVICE_MAVEN_MAPPING_ID"* ]]; then
      break
    fi
    sleep 10
  done

  #check if the logs contains the artifact info
  run echo "$inspect_log"
  assert_output --partial $BUILD_SERVICE_MAVEN_MAPPING_ID
  echo "Maven build successful - $BUILD_SERVICE_MAVEN_MAPPING_ID" >&3
}

