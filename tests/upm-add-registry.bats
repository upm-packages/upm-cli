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

@test "upm-add-registry / single registry configured" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry

  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "scopedRegistries"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "dev.sample.upm"
}

@test "upm-add-registry / multiple registries configured (STDIN)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/multiple.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm1.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry <<<2

  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "scopedRegistries"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "dev.sample.upm2"
}

@test "upm-add-registry / multiple registries configured (parameters)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/multiple.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm2.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry "upm1.sample.dev"

  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "scopedRegistries"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "dev.sample.upm1"
}
