#!/bin/bash

pr_comparison() {
  if [[ "$GITHUB_PULL_REQUEST_EVENT_BODY" =~ $PULL_REQUEST_CONTAINS_PATTERN && ! "$GITHUB_PULL_REQUEST_EVENT_BODY" =~ $PULL_REQUEST_NOT_CONTAINS_PATTERN ]]; then
    BODY_IS_OK=true
  else
    BODY_IS_OK=false
  fi

  if $BODY_IS_OK
  then
    echo "GITHUB_PULL_REQUEST_EVENT_BODY matches"

    return
  else
    echo "GITHUB_PULL_REQUEST_EVENT_BODY not matches"

    false
  fi
}
