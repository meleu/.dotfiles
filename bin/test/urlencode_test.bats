#!/usr/bin/env bats
source "${BATS_TEST_DIRNAME}/setup.bats"

@test "urlencode works for a URL" {
  run urlencode "https://meleu.sh/"
  assert_output "https%3A%2F%2Fmeleu.sh%2F"
}
