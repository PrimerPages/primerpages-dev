# bats_helper.sh

assert_success() {
  if [[ "$status" -ne 0 ]]; then
    echo "Expected success (exit code 0), got $status"
    echo "=== Command Output ==="
    echo "$output"
    echo "======================"
    [[ -n "$1" ]] && echo "$1"
    return 1
  fi
}

assert_failure() {
  if [[ "$status" -eq 0 ]]; then
    echo "Expected failure (non-zero exit), but got 0"
    echo "=== Command Output ==="
    echo "$output"
    echo "======================"
    [[ -n "$1" ]] && echo "$1"
    return 1
  fi
}

assert_output() {
  if [[ "$1" == "--partial" ]]; then
    shift
    assert_output_contains "$@"
  else
    local expected="$1"
    if [[ "$output" != "$expected" ]]; then
      echo "Expected output: $expected"
      echo "Actual output: $output"
      echo "=== Command Output ==="
      echo "$output"
      echo "======================"
      return 1
    fi
  fi
}

assert_output_contains() {
  expected="$1"
  if [[ "$output" != *"$expected"* ]]; then
    echo "Expected output to contain: $expected"
    echo "Actual output: $output"
    echo "=== Command Output ==="
    echo "$output"
    echo "======================"
    return 1
  fi
}
