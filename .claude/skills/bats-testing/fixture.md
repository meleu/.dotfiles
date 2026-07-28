# Fixture Management

## Using Fixture Files

```bash
#!/usr/bin/env bats

# Fixture directory: tests/fixtures/

setup() {
  FIXTURES_DIR="${BATS_TEST_DIRNAME}/fixtures"
  WORK_DIR=$(mktemp -d)
  export WORK_DIR
}

teardown() {
  rm -rf "$WORK_DIR"
}

@test "Process fixture file" {
  # Copy fixture to work directory
  cp "$FIXTURES_DIR/input.txt" "$WORK_DIR/input.txt"

  # Run function
  run my_process_function "$WORK_DIR/input.txt"

  # Compare output
  assert_files_equal "$WORK_DIR/output.txt" "$FIXTURES_DIR/expected_output.txt"
}
```

## Dynamic Fixture Generation

```bash
#!/usr/bin/env bats

generate_fixture() {
  local lines="$1"
  local file="$2"

  for i in $(seq 1 "$lines"); do
      echo "Line $i content" >> "$file"
  done
}

@test "Handle large input file" {
  generate_fixture 1000 "$TMPDIR/large.txt"
  run my_function "$TMPDIR/large.txt"
  assert_success
  assert [ "$(wc -l < "$TMPDIR/large.txt")" -eq 1000 ]
}
```
