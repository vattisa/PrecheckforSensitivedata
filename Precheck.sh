#!/bin/bash

# Define an array of sensitive strings
SENSITIVE_STRINGS=("password" "token" "secret")

while read oldrev newrev refname; do
    # Check each commit in the push
    for commit in $(git rev-list $oldrev..$newrev); do
        # Search for sensitive patterns
        for pattern in "${SENSITIVE_STRINGS[@]}"; do
            if git diff-tree --no-commit-id --name-only -r $commit | grep -q "$pattern"; then
                echo "Error: Commit $commit contains sensitive data ('$pattern')."
                exit 1  # Reject the push
            fi
        done
    done
done
exit 0  # Allow the push if no sensitive data is found


