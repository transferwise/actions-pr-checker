#!/bin/bash


# Send emoji to PR description
# @param - GITHUB_PULL_REQUEST_EVENT_NUMBER
# @param - EMOJI
sendReaction() {
    local GITHUB_ISSUE_NUMBER="$1"
    local EMOJI="$2"

    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.squirrel-girl-preview+json" \
         -X POST \
         -H "Content-Type: application/json" \
         -d "{\"content\":\"${EMOJI}\"}" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${GITHUB_ISSUE_NUMBER}/reactions"
}


# Remove emoji from PR description
# @param - GITHUB_PULL_REQUEST_EVENT_NUMBER
# @param - EMOJI
removeReaction() {
    local GITHUB_ISSUE_NUMBER="$1"
    local EMOJI="$2"

    LIST=$(curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.squirrel-girl-preview+json" \
         -X GET \
         -H "Content-Type: application/json" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${GITHUB_ISSUE_NUMBER}/reactions" \
        )
    COMMENT_ID=$(echo "${LIST}" | jq ".[] | select (.content | contains(\"${EMOJI}\")) | .id")
    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.squirrel-girl-preview+json" \
         -X DELETE \
         -H "Content-Type: application/json" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${GITHUB_ISSUE_NUMBER}/reactions/${COMMENT_ID}"
}


# Send comment to PR
# @param - GITHUB_PULL_REQUEST_EVENT_NUMBER
# @param - comment text
sendComment() {
    local GITHUB_ISSUE_NUMBER="$1"
    local GITHUB_ISSUE_COMMENT="$2"

    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3+json" \
         -X POST \
         -H "Content-Type: application/json" \
         -d "{\"body\":\"${GITHUB_ISSUE_COMMENT}\"}" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${GITHUB_ISSUE_NUMBER}/comments"
}


# Comment requesting changes to PR
# @param - GITHUB_PULL_REQUEST_EVENT_NUMBER
# @param - comment text
requestChangesComment() {
    local GITHUB_ISSUE_NUMBER="$1"
    local GITHUB_ISSUE_COMMENT="$2"

    LIST=$(curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3+json" \
         -X GET \
         -H "Content-Type: application/json" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${GITHUB_ISSUE_NUMBER}/reviews" \
        )
    LAST_STATE=$(echo "${LIST}" | jq -r "last( .[] | select (.user.login | contains(\"github-actions[bot]\")) | .state )")
    echo $LAST_STATE
    if [[ $LAST_STATE -eq "CHANGES_REQUESTED" ]]; then
      return 0
    fi

    echo "ask for changes"
    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3+json" \
         -X POST \
         -H "Content-Type: application/json" \
         -d "{\"body\":\"${GITHUB_ISSUE_COMMENT}\", \"event\":\"REQUEST_CHANGES\"}" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${GITHUB_ISSUE_NUMBER}/reviews"
}


# Approve PR
# @param - GITHUB_PULL_REQUEST_EVENT_NUMBER
approvePr() {
    local GITHUB_ISSUE_NUMBER="$1"

    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3+json" \
         -X POST \
         -H "Content-Type: application/json" \
         -d "{\"event\":\"APPROVE\"}" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${GITHUB_ISSUE_NUMBER}/reviews"
}


# Close PR
# @param - GITHUB_PULL_REQUEST_EVENT_NUMBER
closeIssue() {
    local GITHUB_ISSUE_NUMBER="$1"

    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3+json" \
         -X POST \
         -H "Content-Type: application/json" \
         -d "{\"state\":\"closed\"}" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${GITHUB_ISSUE_NUMBER}"
}
