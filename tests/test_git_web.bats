#!/usr/bin/env bats

function setup {
    # override default output of uname
    function uname {
        echo "Linux"
    }

    gw="$PWD/git-web"
    target="$(mktemp -d)"
    cd "$target"

    git init

    # Use a test configuration for committing
    git config --local commit.gpgsign false
    git config --local user.email "test@test.com"
    git config --local user.name "Test User"

}

function teardown {
    rm -rf "$target"
}


@test 'git-web -> exits on missing remote' {
    run "$gw" idontexist

    echo "$output"

    [ $status -eq 1 ]
    [ "${lines[0]}" = "fatal: No such remote 'idontexist'" ]
    [ "${lines[1]}" = "available remotes:" ]
    [ -z "${lines[2]}" ]
}

@test 'git web -> exits on unknown remote format' {
    git remote add bad "yellow://badformat"

    run "$gw" bad

    [ $status -eq 3 ]
    [ "$output" = "Could not determine target url to open for 'bad' (yellow://badformat)" ]
}
