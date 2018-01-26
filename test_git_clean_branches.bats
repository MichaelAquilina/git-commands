#!/usr/bin/env bats
@test "cleans out of date branches" {
  git branch my_test_branch
  rev="$(git rev-parse --short my_test_branch)"
  run ./git-clean-branches

  echo "$output"
  echo "$rev"
  [ "$status" -eq 0 ]
  [ "$output" = "Deleted branch my_test_branch (was $rev)." ]
}
