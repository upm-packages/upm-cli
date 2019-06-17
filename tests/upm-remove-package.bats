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

@test "upm-remove-package / normal (STDIN)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry
  run ${cwd}/upm add package dev.sample.upm.foo 1.2.3
  run ${cwd}/upm remove package <<<"dev.sample.upm.foo"

  cat "${TEST_TEMP_DIR}/Test-Project/Assets/package.json"

  refute_output --partial "dev.sample.upm.foo"

  cat "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json"

  refute_output --partial "dev.sample.upm.foo"
}

@test "upm-remove-package / normal (parameters)" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry
  run ${cwd}/upm add package dev.sample.upm.foo 1.2.3
  run ${cwd}/upm remove package dev.sample.upm.foo

  cat "${TEST_TEMP_DIR}/Test-Project/Assets/package.json"

  refute_output --partial "dev.sample.upm.foo"

  cat "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json"

  refute_output --partial "dev.sample.upm.foo"
}

@test "upm-remove-package / package does not exists" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm.sample.dev Test.Project "Test Project" Description
  cd $TEST_TEMP_DIR/Test-Project
  run ${cwd}/upm add registry
  run ${cwd}/upm add package dev.sample.upm.foo 1.2.3
  run ${cwd}/upm remove package dev.sample.upm.bar

  assert_output --regexp "\"dev.sample.upm.bar\" does not contains in \"Assets/package.json\""
  assert_output --regexp "\"dev.sample.upm.bar\" does not contains in \"Packages/manifest.json\""
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"dev.sample.upm.foo\": \"1.2.3\""
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Packages/manifest.json" "\"dev.sample.upm.foo\": \"1.2.3\""
}
