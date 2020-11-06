#!/bin/bash

#
# Original: https://github.com/FabianKoestring/body-regex-validator-action/blob/master/entrypoint.sh
#

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "Set the GITHUB_REPOSITORY env variable."
  exit 1
fi

if [[ -z "$GITHUB_EVENT_PATH" ]]; then
  echo "Set the GITHUB_EVENT_PATH env variable."
  exit 1
fi

if [[ -z "$GITHUB_EVENT_NAME" ]]; then
  echo "Set the GITHUB_EVENT_NAME env variable."
  exit 1
fi

#if [[ -z "$PULL_REQUEST_PATTERN" && -z "$ISSUE_PATTERN" ]]; then
#  echo "Set either the PULL_REQUEST_PATTERN or the ISSUE_PATTERN env variables."
#  exit 1
#fi

if [[ ! -z "$PULL_REQUEST_PATTERN" && -z "$PULL_REQUEST_COMMENT" ]]; then
  echo "Set the PULL_REQUEST_COMMENT env variable."
  exit 1
fi

if [[ ! -z "$ISSUE_PATTERN" && -z "$ISSUE_COMMENT" ]]; then
  echo "Set the ISSUE_COMMENT env variable."
  exit 1
fi

if [[ -z "$PULL_REQUEST_CONTAINS_PATTERN" ]]; then
  PULL_REQUEST_CONTAINS_PATTERN=$PULL_REQUEST_PATTERN
fi

if [[ -z "$PULL_REQUEST_CONTAINS_PATTERN" ]]; then
  PULL_REQUEST_CONTAINS_PATTERN=".*"
fi

if [[ -z "$PULL_REQUEST_NOT_CONTAINS_PATTERN" ]]; then
  PULL_REQUEST_NOT_CONTAINS_PATTERN="pseudo-long-string-constant"
fi

if [[ -z "$FAIL_CLOSES_PR" ]]; then
  FAIL_CLOSES_PR=false
fi

if [[ -z "$FAIL_EXITS" ]]; then
  FAIL_EXITS=true
fi


sendReaction() {
    local GITHUB_ISSUE_NUMBER="$1"

    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.squirrel-girl-preview+json" \
         -X POST \
         -H "Content-Type: application/json" \
         -d "{\"content\":\"eyes\"}" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${GITHUB_ISSUE_NUMBER}/reactions"
}

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

main() {
    GITHUB_EVENT_ACTION=$(jq --raw-output .action "$GITHUB_EVENT_PATH")

    echo "GITHUB_EVENT_PATH: ${GITHUB_EVENT_PATH}"
    echo "GITHUB_EVENT_ACTION: ${GITHUB_EVENT_ACTION}"
    echo "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"

    # handle pull_request
    if [[ "$GITHUB_EVENT_NAME" == "pull_request" ]]; then  # && "$GITHUB_EVENT_ACTION" == "opened"
        GITHUB_PULL_REQUEST_EVENT_NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
        GITHUB_PULL_REQUEST_EVENT_BODY=$(jq --raw-output .pull_request.body "$GITHUB_EVENT_PATH")

        echo "GITHUB_PULL_REQUEST_EVENT_NUMBER: ${GITHUB_PULL_REQUEST_EVENT_NUMBER}"
        echo "GITHUB_PULL_REQUEST_EVENT_BODY:"
        echo "$GITHUB_PULL_REQUEST_EVENT_BODY"

    if [[ "$GITHUB_PULL_REQUEST_EVENT_BODY" =~ $PULL_REQUEST_CONTAINS_PATTERN && ! "$GITHUB_PULL_REQUEST_EVENT_BODY" =~ $PULL_REQUEST_NOT_CONTAINS_PATTERN ]]
        then
            echo "GITHUB_PULL_REQUEST_EVENT_BODY matches"
            sendReaction "$GITHUB_PULL_REQUEST_EVENT_NUMBER"
            echo "reaction sent"
        else
            echo "GITHUB_PULL_REQUEST_EVENT_BODY not matches"
            sendComment "$GITHUB_PULL_REQUEST_EVENT_NUMBER" "$PULL_REQUEST_COMMENT"
            echo "sent comment"

            if [[ "$FAIL_CLOSES_PR" == true ]]; then
              closeIssue "$GITHUB_PULL_REQUEST_EVENT_NUMBER"
              echo "pr closed"
            fi

            if [[ "$FAIL_EXITS" == true ]]; then
              exit 1
            fi
        fi
    fi

    exit 0
}

main
