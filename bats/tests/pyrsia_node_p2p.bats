#!/usr/bin/env bash
# node host
NODE_HOST="localhost:7888"
# common setup
COMMON_SETUP='common-setup'
# docker compose file
DOCKER_COMPOSE_DIR="$REPO_DIR/bats/tests/resources/docker/docker-compose_single_node.yml"
# maven build service mapping ID
BUILD_SERVICE_MAVEN_MAPPING_ID="commons-codec:commons-codec:1.15"
# maven artifact URL
MAVEN_ARTIFACT_URL="http://$NODE_HOST/maven2/commons-codec/commons-codec/1.15/commons-codec-1.15.jar"
MAVEN_ARTIFACT_URL_FAKE="http://$NODE_HOST/maven2/fake/fake_artifact.jar"

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

@test "Testing artifactory download from the pyrsia node, maven." {
    # init the build
    run "$PYRSIA_CLI" build maven --gav $BUILD_SERVICE_MAVEN_MAPPING_ID

    # waiting until the build is done => inspect logs available
    echo -e "\t- Adding $BUILD_SERVICE_MAVEN_MAPPING_ID to the pyrsia node, it might take a while..." >&3

    # shellcheck disable=SC2034
    for i in {0..40}
    do
      inspect_log=$($PYRSIA_CLI inspect-log maven --gav $BUILD_SERVICE_MAVEN_MAPPING_ID)
      if [[ "$inspect_log" == *"$BUILD_SERVICE_MAVEN_MAPPING_ID"* ]]; then
        break
      fi
      sleep 5
    done
    #check if the logs contains the artifact info
    run echo "$inspect_log"
    assert_output --partial "$BUILD_SERVICE_MAVEN_MAPPING_ID"

    # false negative, try to download non existing maven artifact
    echo -e "\t- Test downloading a non existing artifactory from the pyrsia node" >&3
    run wget "$MAVEN_ARTIFACT_URL_FAKE"
    assert_output --partial "500 Internal Server Error"

    echo -e "\t- Test downloading $BUILD_SERVICE_MAVEN_MAPPING_ID artifact from the pyrsia node - $MAVEN_ARTIFACT_URL_FAKE" >&3
    run wget $MAVEN_ARTIFACT_URL
    assert_output --partial "200 OK"
}