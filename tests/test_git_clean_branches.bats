#!/usr/bin/env bats

function setup {
    gcb="$PWD/git-clean-branches"
    target="$(mktemp -d)"
    cd "$target"

    # Use a test configuration for committing
    git init

    defaultBranch="$(git config init.defaultBranch)"
    main="${defaultBranch:-master}"

    git config --local commit.gpgsign false
    git config --local user.email "test@test.com"
    git config --local user.name "Test User"
}


function teardown {
    rm -rf "$target"
}

@test 'git-clean-branches -> we are working in a git directory' {
    run git status

    [ $status -eq 0 ]
    [ "${lines[0]}" = "On branch ${main}" ]
}


@test 'git-clean-branches -> nothing removed on empty git dir' {
    run "$gcb"

    [ $status -eq 0 ]
    [ -z "$output" ]
}


@test 'git-clean-branches -> nothing deleted if no old branches exist' {
    touch "hello.txt"
    git add hello.txt
    git commit -m "test commit"

    run "$gcb"

    [ $status -eq 0 ]
    [ -z "$output" ]
}


@test 'git-clean-branches -> cleans out branches with no commits' {
  touch "hello.txt"
  git add hello.txt
  git commit -m "test commit"
  git branch empty_branch
  commit_id="$(git rev-parse --short empty_branch)"

  run "$gcb"

  [ $status -eq 0 ]
  [ "$output" = "Deleted branch empty_branch (was $commit_id)." ]
}


@test 'git-clean-branches -> does not clean out non-empty unmerged branches' {
  touch "hello.txt"
  git add hello.txt
  git commit -m "test commit"

  git checkout -b non_empty_branch
  echo hello > "hello.txt"
  git commit -am "updated commit"

  git checkout "${main}"

  run "$gcb"

  [ $status -eq 0 ]
  [ -z "$output" ]
}

@test 'git-clean-branches -> different default target' {
  touch "hello.txt"
  git checkout -b develop
  git add hello.txt
  git commit -m "test commit"

  # Start off a new branch
  git checkout -b merged_branch
  echo hello > "hello.txt"
  git commit -am "updated commit"
  commit_id="$(git rev-parse --short merged_branch)"

  git checkout develop

  # make sure its not simplified into a rebase
  echo "hello" > hello2.txt
  git add .
  git commit -m "develop commit"

  git merge merged_branch

  run "$gcb" develop

  [ $status -eq 0 ]
  [ "$output" = "Deleted branch merged_branch (was $commit_id)." ]
}


@test 'git-clean-branches -> does clean out non-empty merged branches' {
  touch "hello.txt"
  git add hello.txt
  git commit -m "test commit"

  # Start off a new branch
  git checkout -b merged_branch
  echo hello > "hello.txt"
  git commit -am "updated commit"
  commit_id="$(git rev-parse --short merged_branch)"

  git checkout "${main}"

  # make sure its not simplified into a rebase
  echo "hello" > hello2.txt
  git add .
  git commit -m "master commit"

  git merge merged_branch

  run "$gcb"

  [ $status -eq 0 ]
  [ "$output" = "Deleted branch merged_branch (was $commit_id)." ]
}
