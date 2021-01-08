#!/bin/bash

shopt -s nocasematch

body_comparison() {
  if [[ ! "$GITHUB_PULL_REQUEST_EVENT_BODY" =~ $PR_CONTAINS_PATTERN ]]
  then
    echo "PR description does not match pattern \"${PR_CONTAINS_PATTERN}\""
    return 1
  fi

  if [[ "$GITHUB_PULL_REQUEST_EVENT_BODY" =~ $PR_NOT_CONTAINS_PATTERN ]]
  then
    echo "PR description should not contain pattern \"${PR_NOT_CONTAINS_PATTERN}\""
    return 1
  fi

  return 0
}


title_comparison() {
  if [[ ! "$GITHUB_PULL_REQUEST_EVENT_TITLE" =~ $PR_TITLE_CONTAINS_PATTERN ]]
  then
    echo "PR title \"${GITHUB_PULL_REQUEST_EVENT_TITLE}\" does not match pattern \"${PR_TITLE_CONTAINS_PATTERN}\""
    return 1
  fi

  if [[ "$GITHUB_PULL_REQUEST_EVENT_TITLE" =~ $PR_TITLE_NOT_CONTAINS_PATTERN ]]
  then
    echo "PR title \"${GITHUB_PULL_REQUEST_EVENT_TITLE}\" should not contain pattern \"${PR_TITLE_NOT_CONTAINS_PATTERN}\""
    return 1
  fi

  return 0
}


tags_comparison() {
  #TODO
  return 0
}
