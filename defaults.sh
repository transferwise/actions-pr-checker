#!/bin/bash

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

#if [[ ! -z "$PULL_REQUEST_PATTERN" && -z "$PR_COMMENT" ]]; then
#  echo "Set the PR_COMMENT env variable."
#  exit 1
#fi
#
#if [[ ! -z "$ISSUE_PATTERN" && -z "$ISSUE_COMMENT" ]]; then
#  echo "Set the ISSUE_COMMENT env variable."
#  exit 1
#fi

if [[ -z "$PR_CONTAINS_PATTERN" ]]; then
  PR_CONTAINS_PATTERN=$PULL_REQUEST_PATTERN
fi

if [[ -z "$PR_CONTAINS_PATTERN" ]]; then
  PR_CONTAINS_PATTERN=".*"
fi

if [[ -z "$PR_NOT_CONTAINS_PATTERN" ]]; then
  PR_NOT_CONTAINS_PATTERN="pseudo-long-string-constant"
fi

if [[ -z "$PR_TITLE_CONTAINS_PATTERN" ]]; then
  PR_TITLE_CONTAINS_PATTERN=".*"
fi

if [[ -z "$PR_TITLE_NOT_CONTAINS_PATTERN" ]]; then
  PR_TITLE_NOT_CONTAINS_PATTERN="pseudo-long-string-constant"
fi

if [[ -z "$PR_COMMENT" ]]; then
  PR_COMMENT="Please check description. \nShould be meaningful and not empty."
fi

if [[ -z "$SUCCESS_EMOJI" ]]; then
  SUCCESS_EMOJI="+1"
fi

if [[ -z "$FAIL_CLOSES_PR" ]]; then
  FAIL_CLOSES_PR=false
fi

if [[ -z "$FAIL_EXITS" ]]; then
  FAIL_EXITS=true
fi

if [[ -z "$SUCCESS_APPROVES_PR" ]]; then
  SUCCESS_APPROVES_PR=true
fi
