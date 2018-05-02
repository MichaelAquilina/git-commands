#!/usr/bin/env bats

function setup {
    # override default output of uname
    function uname {
        echo "Linux"
    }
    function xdg-open {
        echo "Opening $1 (Linux)"
    }
    function open {
        echo "Opening $1 (OSX)"
    }

    export -f open
    export -f xdg-open
    export -f uname

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

@test 'git web -> exits on unknown target platform' {
    git remote add origin git@gitbuddy.com:Repo1/foobar.git

    function uname {
        echo 'Hal9000'
    }
    export -f uname

    run "$gw"

    [ $status -eq 2 ]
    [ "$output" = "Unknown target platform 'Hal9000'" ]
}


@test 'git web -> works with ssh remotes' {
    git remote add origin git@gitbuddy.com:SomeRepo/baz.git

    run "$gw"

    [ $status -eq 0 ]
    [ "$output" = "Opening https://gitbuddy.com/SomeRepo/baz (Linux)" ]
}

@test 'git web -> works with https remotes' {
    git remote add origin https://gitwarrior.com/power/bar.git

    run "$gw"

    [ $status -eq 0 ]
    [ "$output" = "Opening https://gitwarrior.com/power/bar (Linux)" ]
}

@test 'git web -> works with osx' {
    git remote add origin https://gitapple.com/red/blue.git

    function uname {
        echo "Darwin"
    }
    export -f uname

    run "$gw"

    [ $status -eq 0 ]
    [ "$output" = "Opening https://gitapple.com/red/blue (OSX)" ]
}

@test 'git-web -> specify different remote' {
    git remote add origin git@gitbuddy.com:SomeRepo/baz.git
    git remote add upstream git@github.com:MAquilina/git-web.git

    run "$gw" upstream

    [ $status -eq 0 ]
    [ "$output" = "Opening https://github.com/MAquilina/git-web (Linux)" ]
}

@test 'git web -> --issues' {
    git remote add origin git@kdgit.com:Warm/Gorm.git

    run "$gw" "--issues"

    [ $status -eq 0 ]
    [ "$output" = "Opening https://kdgit.com/Warm/Gorm/issues/ (Linux)" ]
}

@test 'git web -> --issues with specific remote' {
    git remote add origin git@bitbucket.org:red/green.git
    git remote add upstream git@gitlab.com:red/green.git

    run "$gw" "--issues" "upstream"

    [ $status -eq 0 ]
    [ "$output" = "Opening https://gitlab.com/red/green/issues/ (Linux)" ]
}
