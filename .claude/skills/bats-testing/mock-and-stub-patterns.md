# Mocking and Stubbing Patterns

## Function Mocking

```bash
#!/usr/bin/env bats

# A function with the name of an external tool mocks its behavior
my_external_tool() {
  echo "mocked output"
  return 0
}

@test "Function uses mocked tool" {
  export -f my_external_tool
  run my_function
  assert_output --partial "mocked output"
}
```

## Command Stubbing

```bash
#!/usr/bin/env bats

setup() {
  # Create stub directory
  STUBS_DIR="$TMPDIR/stubs"
  mkdir -p "$STUBS_DIR"

  export PATH="$STUBS_DIR:$PATH"
}

teardown() {
  rm -rf "$STUBS_DIR"
}

create_stub() {
  local cmd="$1"
  local output="$2"
  local code="${3:-0}"

  cat > "$STUBS_DIR/$cmd" <<EOF
#!/bin/bash
echo "$output"
exit $code
EOF
  chmod +x "$STUBS_DIR/$cmd"
}

@test "Function works with stubbed curl" {
  create_stub curl "{ \"status\": \"ok\" }" 0
  run my_api_function
  assert_success
}
```
