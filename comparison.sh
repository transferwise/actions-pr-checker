#!/bin/bash

pr_comparison() {
  BODY_IS_OK=true
  if [[ "$GITHUB_PULL_REQUEST_EVENT_BODY" =~ $PULL_REQUEST_CONTAINS_PATTERN && ! "$GITHUB_PULL_REQUEST_EVENT_BODY" =~ $PULL_REQUEST_NOT_CONTAINS_PATTERN ]]
  then
    return
  else
    false
  fi
}
