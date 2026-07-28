#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  URLENCODE="${BATS_TEST_DIRNAME}/../urlencode"
}

@test "keeps unreserved characters untouched" {
  run "$URLENCODE" 'abcXYZ0189.~_-'
  assert_output 'abcXYZ0189.~_-'
}

@test "encodes a space as %20" {
  run "$URLENCODE" 'hello world'
  assert_output 'hello%20world'
}

@test "joins multiple arguments with an encoded space" {
  run "$URLENCODE" a b c
  assert_output 'a%20b%20c'
}

@test "encodes the percent sign itself" {
  run "$URLENCODE" '100%'
  assert_output '100%25'
}

@test "encodes reserved URI characters" {
  run "$URLENCODE" ':/?#[]@!$&'"'"'()*+,;='
  assert_output '%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D'
}

@test "encodes other punctuation and symbols" {
  # shellcheck disable=1003
  run "$URLENCODE" '"<>^`{|}\'
  assert_output '%22%3C%3E%5E%60%7B%7C%7D%5C'
}

@test "encodes an embedded newline" {
  run "$URLENCODE" "$(printf 'a\nb')"
  assert_output 'a%0Ab'
}

@test "encodes non-ASCII characters byte by byte (UTF-8)" {
  run "$URLENCODE" 'olá'
  assert_output 'ol%C3%A1'
}

@test "encodes multi-byte characters outside the Latin range" {
  run "$URLENCODE" '日本'
  assert_output '%E6%97%A5%E6%9C%AC'
}

@test "encodes a whole URL, including the scheme separators" {
  run "$URLENCODE" 'https://example.com/a b?c=d&e=f'
  assert_output 'https%3A%2F%2Fexample.com%2Fa%20b%3Fc%3Dd%26e%3Df'
}

@test "outputs nothing but a newline when called without arguments" {
  run "$URLENCODE"
  assert_output ''
}

@test "outputs nothing but a newline for an empty argument" {
  run "$URLENCODE" ''
  assert_output ''
}

@test "does not interpret backslash escapes in the input" {
  run "$URLENCODE" 'a\tb'
  assert_output 'a%5Ctb'
}

@test "does not expand printf format specifiers from the input" {
  run "$URLENCODE" '%s%d'
  assert_output '%25s%25d'
}
