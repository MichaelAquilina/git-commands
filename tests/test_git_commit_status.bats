function setup {
    export PATH="$PWD:$PATH"

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

@test 'git-commit-status -> uses GITHUB_API_KEY_PASS_NAME' {
    git remote add origin git@github.com:foo/bar.git

    # test should ensure we prefer pass integration
    export GITHUB_API_KEY="blablabla"
    export GITHUB_API_KEY_PASS_NAME="Super/Sekret/Key"

    function pass {
        local name="${@: -1}"
        if [[ "$name" == "Super/Sekret/Key" ]]; then
            printf "github-sekret-api-key"
        fi
    }

    function curl {
        local url="${@: -1}"
        local auth="${@: -2:1}"
        if [ "$auth" != "Authorization: Bearer github-sekret-api-key" ]; then
            printf 'boom'  # invalid JSON will fail the test
        elif [[ "$url" == *"/status" ]]; then
            printf '{"stasuses": []}'
        elif [[ "$url == */check-runs" ]]; then
            printf '{"check_runs": []}'
        fi
    }

    export -f curl
    export -f pass

    run git commit-status

    [ $status -eq 0 ]
}

@test 'git-commit-status -> uses GITHUB_API_KEY' {
    git remote add origin git@github.com:foo/bar.git

    # test should ensure we prefer pass integration
    export GITHUB_API_KEY="so-sekret-this-key"

    function curl {
        local url="${@: -1}"
        local auth="${@: -2:1}"
        if [ "$auth" != "Authorization: Bearer so-sekret-this-key" ]; then
            printf 'boom'  # invalid JSON will fail the test
        elif [[ "$url" == *"/status" ]]; then
            printf '{"stasuses": []}'
        elif [[ "$url == */check-runs" ]]; then
            printf '{"check_runs": []}'
        fi
    }

    export -f curl

    run git commit-status

    [ $status -eq 0 ]
}

@test 'git-commit-status -> prints commit status' {
    git remote add origin git@github.com:foo/bar.git
    function curl {
        local url="${@: -1}"
        if [[ "$url" == *"/status" ]]; then
            printf '{
                "statuses": [
                    {
                        "state": "success",
                        "target_url": "https://ci.com/1234",
                        "context": "tests"
                    },
                    {
                        "state": "failure",
                        "target_url": "https://ci.com/1245",
                        "context": "lint"
                    }
                ]
            }'
        elif [[ "$url == */check-runs" ]]; then
            printf '{"check_runs": []}'
        fi
    }
    export -f curl

    run git commit-status

    [ $status -eq 0 ]
    [[ "${lines[0]}" =~ success:\ tests ]]
    [[ "${lines[1]}" =~ failure:\ lint ]]
}

@test 'git-commit-status -> prints check runs' {
    git remote add origin git@github.com:foo/bar.git
    function curl {
        local url="${@: -1}"
        if [[ "$url" == *"/status" ]]; then
            printf '{"statuses": []}'
        elif [[ "$url == */check-runs" ]]; then
            printf '{
                "check_runs": [
                    {
                        "status": "pending",
                        "html_url": "https://ceye.org/abcd",
                        "name": "deploy to prod"
                    }
                ]
            }'
        fi
    }
    export -f curl

    run git commit-status

    [ $status -eq 0 ]
    [[ "$output" =~ pending:\ deploy\ to\ prod ]]
}


@test 'git-commit-status -> gracefully handle errors' {
    git remote add origin git@github.com:test/test.git
    function curl {
        printf '{"status": "404", "message": "Not Found"}'
    }
    export -f curl

    run git commit-status

    [ $status -eq 1 ]
    [ "$output" == "404: Not Found" ]
}

@test 'git-commit-status -> warns for unsupported providers' {
    git remote add origin git@gitlab.com:test/test.git

    run git commit-status

    [ $status -eq 1 ]
    [ "$output" == "Unknown or unsupported API for https://gitlab.com/test/test" ]
}
