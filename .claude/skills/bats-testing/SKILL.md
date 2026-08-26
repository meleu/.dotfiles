---
name: bats-testing
description: Expert guidance for writing comprehensive tests for bash code using BATS (Bash Automated Testing System). Use when writing tests for shell scripts with BATS.
---

# Bats Testing Practices

Guidance for writing comprehensive unit tests for shell scripts using BATS,
including test patterns, fixtures, and best practices for production-grade shell testing.

## BATS Availability

Always assume `bats` is available. Inform the user if it's not.

**NOTE**: all the examples here assume you're using BATS with the helpers bats-support and bats-assert.

## Basic Test Structure

Example:

```bash
#!/usr/bin/env bats

# Setup runs before each test
setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  export TMPDIR=$(mktemp -d)
}

# Teardown runs after each test
teardown() {
  rm -rf "$TMPDIR"
}

# simple assertions
@test "Function returns 0 on success" {
  run my_function "an_argument"
  assert_success
}

@test "Function returns 1 on missing argument" {
  run my_function
  assert_failure
}

@test "Function outputs correct result" {
  run my_function "test"
  assert_output "expected output"
}
```

## Setup and Teardown Patterns

### Basic Setup and Teardown

```bash
#!/usr/bin/env bats

# Setup runs before each test
setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  export TMPDIR=$(mktemp -d)

  # Source script under test
  source "${BATS_TEST_DIRNAME}/../bin/script.sh"
}

# Teardown runs after each test
teardown() {
  rm -rf "$TMPDIR"
}
```

### Global Setup/Teardown

```bash
#!/usr/bin/env bats

# setup_file runs once before all tests
setup_file() {
  export SHARED_RESOURCE=$(mktemp -d)
  echo "Expensive setup" > "$SHARED_RESOURCE/data.txt"
}

# teardown_file runs once after all tests
teardown_file() {
  rm -rf "$SHARED_RESOURCE"
}

@test "First test uses shared resource" {
  # ...
  assert_file_exists "$SHARED_RESOURCE/data.txt"
}

@test "Second test uses shared resource" {
  # ...
  assert_dir_exists "$SHARED_RESOURCE"
}
```

## Mocking and Stubbing Patterns

If you need mocking and/or stubbing, check [mock-and-stub-patterns.md](./mock-and-stub-patterns.md).

## Fixture Management

If you need to create fixtures, check [fixture.md](./fixture.md).

## Best Practices

1. **Test one behavior per test** - single responsibility principle
2. **Use descriptive test names** - clearly states what is being tested
3. **Clean up after tests** - remove temporary files in teardown
4. **Test both success and failure paths** - don't just test happy path
5. **Mock external dependencies** - isolate unit under test
6. **Use fixtures for complex data** - makes tests more readable
7. **Keep tests fast** - run in parallel when possible

## Resources

- **Bats Documentation**: <https://bats-core.readthedocs.io/>
- **Bats GitHub**: <https://github.com/bats-core/bats-core>
- **Bats basic assertions**: <https://github.com/bats-core/bats-assert/blob/master/README.md>
