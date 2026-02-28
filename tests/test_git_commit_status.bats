function setup {
    gcs="$PWD/git-commit-status"
    gw="$PWD/git-web"

    function git-web {
        "$gw"
    }
    export -f git-web

    # Create test git directory
    target="$(mktemp -d)"
    cd "$target"
    git init

    # Use a test configuration for committing
    git config --local web.opencommand ""
    git config --local commit.gpgsign false
    git config --local user.email "test@test.com"
    git config --local user.name "Test User"

    export GITHUB_API_KEY_PASS_NAME=""
    export GITHUB_API_KEY=""

    touch "empty.txt"
    git add empty.txt
    git commit -m "Initial Commit"
}

function teardown {
    rm -rf "$target"
}


@test 'gracefully handle errors' {
    git remote add origin git@github.com:test/test.git
    function curl {
        printf '{"status": "404", "message": "Not Found"}'
    }
    export -f curl

    run "$gcs"

    [ $status -eq 1 ]
    [ "$output" == "404: Not Found" ]
}

@test 'warns for unsupported providers' {
    git remote add origin git@gitlab.com:test/test.git

    run "$gcs"

    [ $status -eq 1 ]
    [ "$output" == "Unknown or unsupported API for https://gitlab.com/test/test" ]
}
