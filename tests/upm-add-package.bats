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

@test "upm-add-package / normal (STDIN)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry
  run ${cwd}/upm add package <<<"dev.sample.upm.foo
1.2.3"

  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"dev.sample.upm.foo\": \"1.2.3\""
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "\"dev.sample.upm.foo\": \"1.2.3\""
}

@test "upm-add-package / normal (parameters)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry
  run ${cwd}/upm add package dev.sample.upm.bar 2.3.4

  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"dev.sample.upm.bar\": \"2.3.4\""
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "\"dev.sample.upm.bar\": \"2.3.4\""
}

@test "upm-add-package / package domain does not match" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry
  run ${cwd}/upm add package dev.sample2.upm.foo 1.2.3

  assert_output --partial "Could not find registry for dev.sample2.upm.foo"
}
