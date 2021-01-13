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
  # Disable globbing, remember current -f flag value
  [[ "$-" == *f* ]] || globbing_disabled=1
  set -f
  IFSSS=$IFS
  IFS=$'\n'
  TAG_LIST=( $(echo $GITHUB_PULL_REQUEST_EVENT_LABELS | jq -r '.[].name') )
  # Restore globbing
  test -n "$globbing_disabled" && set +f
  IFS=$IFSSS

  # check tags count
  TAG_COUNT="${#TAG_LIST[@]}"
  if [[ $TAG_COUNT -lt $PR_TAGS_MIN_COUNT ]]; then
    echo "PR tags count is ${TAG_COUNT}, minimum is ${PR_TAGS_MIN_COUNT}"
    return 1
  fi

  # check mandatory tags
  HAVE_MANDATORY_TAG=0
  for TAG in "${TAG_LIST[@]}" ; do
    for S in $PR_TAGS_MANDATORY ; do
      if [[ $S == "$TAG" ]]; then
        HAVE_MANDATORY_TAG=1
      fi
    done
  done
  if [[ -n $PR_TAGS_MANDATORY && $HAVE_MANDATORY_TAG != 1 ]]; then
    echo "PR tags don't have any of required tags: ${PR_TAGS_MANDATORY}"
    return 1
  fi

  # check restricted tags
  for TAG in "${TAG_LIST[@]}" ; do
    HAVE_FORBIDDEN_TAG=1
    for S in $PR_TAGS_RESTRICTED ; do
      if [[ $S == "$TAG" ]]; then
        HAVE_FORBIDDEN_TAG=0
      fi
    done
    if [[ $HAVE_FORBIDDEN_TAG == 1 ]]; then
      break
    fi
  done
  if [[ -n $PR_TAGS_RESTRICTED && $HAVE_FORBIDDEN_TAG == 1 ]]; then
    echo "PR tags should be only: ${PR_TAGS_RESTRICTED}"
    return 1
  fi

  return 0
}
