#!/bin/bash

#
# Inspired by:
# https://github.com/FabianKoestring/body-regex-validator-action/blob/master/entrypoint.sh
#

set -e

echo "sources"

source defaults.sh
source functions.sh

echo "function main"

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
            sendReaction "$GITHUB_PULL_REQUEST_EVENT_NUMBER" "$SUCCESS_EMOJI"
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
