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
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/.npmrc" "upm.sample.dev"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "dev.sample.upm"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"displayName\": \"Test Project\""
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset" "companyName: Sample Company"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset" "productName: Test.Project"
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
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/.npmrc" "upm2.sample.dev"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "dev.sample.upm2"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"displayName\": \"Test Project\""
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset" "companyName: Sample Company2"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset" "productName: Test.Project"
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
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/.npmrc" "upm.sample.dev"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "dev.sample.upm"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"displayName\": \"Test Project\""
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset" "companyName: Sample Company"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset" "productName: Test.Project"
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
  assert_file_exist "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/.npmrc" "upm1.sample.dev"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "dev.sample.upm1"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/Assets/package.json" "\"displayName\": \"Test Project\""
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset" "companyName: Sample Company1"
  assert_file_contains "${TEST_TEMP_DIR}/Test-Project/ProjectSettings/ProjectSettings.asset" "productName: Test.Project"
}

@test "upm-init / invalid Registry Name passed" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/multiple.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init upm3.sample.dev Test.Project "Test Project" Description

  assert_output -p "does not configured in"
}

@test "upm-init / invalid Registry index passed" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/multiple.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init <<<"3
Test.Project
Test Project
Description"

  assert_output -p "Choice value in [1..2]"

  run ${cwd}/upm init <<<"0
Test.Project
Test Project
Description"

  assert_output -p "Choice value in [1..2]"
}

@test "upm-init / Package Name is not passed" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init <<<"
Test Project
Description"

  assert_output -p "Please specify Package Name"
}

@test "upm-init / Display Name is not passed" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/single.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR
  run ${cwd}/upm init <<<"Test.Project

Description"

  assert_output -p "Please specify Display Name"
}

@test "upm-init / generate files about package" {
  cp "$( dirname ${BATS_TEST_DIRNAME} )"/fixtures/multiple.upm-config.json ~/.upm-config.json
  cwd=$(pwd)
  cd $TEST_TEMP_DIR

  run ${cwd}/upm init upm1.sample.dev Test.Project1 "Test Project1" Description

  [ -L "${TEST_TEMP_DIR}/Test-Project1/README.md" ]
  [ ! -L "${TEST_TEMP_DIR}/Test-Project1/Assets/README.md" ]
  [ -L "${TEST_TEMP_DIR}/Test-Project1/CHANGELOG.md" ]
  [ ! -L "${TEST_TEMP_DIR}/Test-Project1/Assets/CHANGELOG.md" ]
  [ ! -L "${TEST_TEMP_DIR}/Test-Project1/LICENSE.txt" ]
  [ ! -L "${TEST_TEMP_DIR}/Test-Project1/Assets/LICENSE.txt" ]

  run ${cwd}/upm init upm2.sample.dev Test.Project2 "Test Project2" Description

  [ -L "${TEST_TEMP_DIR}/Test-Project2/README.md" ]
  [ ! -L "${TEST_TEMP_DIR}/Test-Project2/Assets/README.md" ]
  [ -L "${TEST_TEMP_DIR}/Test-Project2/CHANGELOG.md" ]
  [ ! -L "${TEST_TEMP_DIR}/Test-Project2/Assets/CHANGELOG.md" ]
  [ ! -f "${TEST_TEMP_DIR}/Test-Project2/LICENSE.txt" ]
  [ ! -f "${TEST_TEMP_DIR}/Test-Project2/Assets/LICENSE.txt" ]
}
