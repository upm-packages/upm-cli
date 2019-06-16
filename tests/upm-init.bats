#!/usr/bin/env bats

TEST_NPM_PREFIX="$(npm root -g)"
load "${TEST_NPM_PREFIX}/bats-support/load.bash"
load "${TEST_NPM_PREFIX}/bats-assert/load.bash"
load "${TEST_NPM_PREFIX}/bats-file/load.bash"

function setup() {
  TEST_TEMP_DIR="$(temp_make)"
  if [ -f ~/.upm-config.json ]; then
    mv ~/.upm-config.json ${TEST_TEMP_DIR}/.upm-config.json
  fi
}

function teardown() {
  if [ -f ${TEST_TEMP_DIR}/.upm-config.json ]; then
    mv ${TEST_TEMP_DIR}/.upm-config.json ~/.upm-config.json
  fi
  temp_del "${TEST_TEMP_DIR}"
}

@test "upm-init / no registry configured" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/empty.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init <<<"Test.Project
Test Project
Description"

  assert_output -p "No registries configured"
}

@test "upm-init / single registry configured (STDIN)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init <<<"Test.Project
Test Project
Description"

  assert_output -p "Enjoy development"
  assert_dir_exist "${TEST_TEMP_DIR}/Test-Project"
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/.npmrc"
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/Assets/package.json"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/.npmrc" "upm.sample.dev"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "dev.sample.upm"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"displayName\": \"Test Project\""
}

@test "upm-init / multiple registries configured (STDIN)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/multiple.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init <<<"2
Test.Project
Test Project
Description"

  assert_output -p "Enjoy development"
  assert_dir_exist "${TEST_TEMP_DIR}/Test-Project"
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/.npmrc"
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/Assets/package.json"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/.npmrc" "upm2.sample.dev"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "dev.sample.upm2"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"displayName\": \"Test Project\""
}

@test "upm-init / single registry configured (parameters)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm.sample.dev Test.Project "Test Project" Description

  assert_output -p "Enjoy development"
  assert_dir_exist "${TEST_TEMP_DIR}/Test-Project"
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/.npmrc"
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/Assets/package.json"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/.npmrc" "upm.sample.dev"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "dev.sample.upm"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"displayName\": \"Test Project\""
}

@test "upm-init / multiple registries configured (parameters)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/multiple.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm1.sample.dev Test.Project "Test Project" Description

  assert_output -p "Enjoy development"
  assert_dir_exist "${TEST_TEMP_DIR}/Test-Project"
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/.npmrc"
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/Assets/package.json"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/.npmrc" "upm1.sample.dev"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "dev.sample.upm1"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"displayName\": \"Test Project\""
}
