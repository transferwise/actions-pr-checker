#!/bin/bash

#
# Inspired by:
# https://github.com/FabianKoestring/body-regex-validator-action/blob/master/entrypoint.sh
#

set -e

DIR=$(dirname "$0")
source "${DIR}/defaults.sh"
source "${DIR}/functions.sh"
source "${DIR}/comparison.sh"


main() {
  GITHUB_EVENT_ACTION=$(jq --raw-output .action "$GITHUB_EVENT_PATH")

  echo "GITHUB_EVENT_PATH: ${GITHUB_EVENT_PATH}"
  echo "GITHUB_EVENT_ACTION: ${GITHUB_EVENT_ACTION}"
  echo "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"

  # handle pull_request
  if [[ "$GITHUB_EVENT_NAME" == "pull_request" ]]; then # && "$GITHUB_EVENT_ACTION" == "opened"
    export GITHUB_PULL_REQUEST_EVENT_TITLE=$(jq --raw-output .pull_request.title "$GITHUB_EVENT_PATH")
    export GITHUB_PULL_REQUEST_EVENT_BODY=$(jq --raw-output .pull_request.body "$GITHUB_EVENT_PATH")
    export GITHUB_PULL_REQUEST_EVENT_LABELS=$(jq --raw-output .pull_request.labels "$GITHUB_EVENT_PATH")
    GITHUB_PULL_REQUEST_EVENT_NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

    echo "GITHUB_PULL_REQUEST_EVENT_NUMBER: ${GITHUB_PULL_REQUEST_EVENT_NUMBER}"
    echo "PR_CONTAINS_PATTERN: ${PR_CONTAINS_PATTERN}"
    echo "PR_NOT_CONTAINS_PATTERN: ${PR_NOT_CONTAINS_PATTERN}"

    echo "GITHUB_PULL_REQUEST_EVENT_TITLE:"
    echo "$GITHUB_PULL_REQUEST_EVENT_TITLE"
    echo "GITHUB_PULL_REQUEST_EVENT_LABELS:"
    echo "$GITHUB_PULL_REQUEST_EVENT_LABELS"
    echo "GITHUB_PULL_REQUEST_EVENT_BODY:"
    echo "$GITHUB_PULL_REQUEST_EVENT_BODY"

    body_comparison && title_comparison && tags_comparison && no_comparison
    if [[ $? -eq 0 ]]; then
      send_check_success
    else
      send_check_failed
    fi

  else
    echo "Unknown GitHub event!"
    echo "Exited without error"
  fi

  exit 0
}


send_check_success() {
  sendReaction "$GITHUB_PULL_REQUEST_EVENT_NUMBER" "$SUCCESS_EMOJI"
  echo "reaction sent"

  if [[ "$SUCCESS_APPROVES_PR" == true ]]; then
    approvePr "$GITHUB_PULL_REQUEST_EVENT_NUMBER"
    echo "pr approved"
  fi

  if [[ -n "$SUCCESS_COMMENT" ]]; then
    sendComment "$GITHUB_PULL_REQUEST_EVENT_NUMBER" "$SUCCESS_COMMENT"
    echo "sent success comment"
  fi
}


send_check_failed() {
  if [[ "$SUCCESS_APPROVES_PR" == true ]]; then
    requestChangesComment "$GITHUB_PULL_REQUEST_EVENT_NUMBER" "$PR_COMMENT"
    echo "requested changes"
  else
    sendComment "$GITHUB_PULL_REQUEST_EVENT_NUMBER" "$PR_COMMENT"
    echo "sent comment"
  fi

  removeReaction "$GITHUB_PULL_REQUEST_EVENT_NUMBER" "$SUCCESS_EMOJI"
  echo "reaction removed"

  if [[ "$FAIL_CLOSES_PR" == true ]]; then
    closeIssue "$GITHUB_PULL_REQUEST_EVENT_NUMBER"
    echo "pr closed"
  fi

  if [[ "$FAIL_EXITS" == true ]]; then
    exit 1
  fi
}


main
