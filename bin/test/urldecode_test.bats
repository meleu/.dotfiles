#!/usr/bin/env bats
source "${BATS_TEST_DIRNAME}/setup.bats"

@test "urldecode works for a URL" {
  run urldecode "https%3A%2F%2Fmeleu.sh%2F"
  assert_output "https://meleu.sh/"
}
