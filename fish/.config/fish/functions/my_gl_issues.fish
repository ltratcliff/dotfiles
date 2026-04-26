function my_gl_issues --description "Query GitLab subgroup issues"
    # Ensure the token is set
    if not set -q SEME_GIT_TOKEN
        echo "Error: SEME_GIT_TOKEN environment variable is not set."
        return 1
    end

    set -l group_path "seme-team%2Fengineer-team"

    set -l page 1
    while true
        set -l response (curl -k -s --header "PRIVATE-TOKEN: $SEME_GIT_TOKEN" \
            "https://gitlab.seme.pro/api/v4/groups/$group_path/issues?assignee_username=larry.t.ratcliff&per_page=100&page=$page")
        # Stop when an empty array is returned
        if test "$response" = "[]"
            break
        end
        echo $response
        set page (math $page + 1)
    end
end
