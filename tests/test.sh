#!/bin/bash

GITHUB_TOKEN='fake'
GITHUB_REPOSITORY='fake'
GITHUB_EVENT_PATH='fake'
GITHUB_EVENT_NAME='fake'

DIR=$(dirname "$0")
source "${DIR}/../defaults.sh"
#source "${DIR}/functions.sh"
source "${DIR}/../comparison.sh"
source "${DIR}/assert.sh"

N=0

echo $((i+=1))
GITHUB_PULL_REQUEST_EVENT_BODY="Something"
#echo $PULL_REQUEST_CONTAINS_PATTERN
pr_comparison
assert_eq 0 $? "Nothing set - OK"

echo $((i+=1))
GITHUB_PULL_REQUEST_EVENT_BODY="Hello"
PULL_REQUEST_CONTAINS_PATTERN=".{20,}"
pr_comparison
assert_eq 1 $? "Body not matches pattern - FAIL"

echo $((i+=1))
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PULL_REQUEST_CONTAINS_PATTERN="[TICKET]"
pr_comparison
assert_eq 0 $? "Body matches pattern - OK"

echo $((i+=1))
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PULL_REQUEST_CONTAINS_PATTERN="[TICKET]"
PULL_REQUEST_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
pr_comparison
assert_eq 0 $? "Body matches pattern and NOT pattern - OK"

echo $((i+=1))
GITHUB_PULL_REQUEST_EVENT_BODY="This is default text.\n Why is this PR necessary?\nAdd text."
PULL_REQUEST_CONTAINS_PATTERN="[TICKET]"
PULL_REQUEST_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
pr_comparison
assert_eq 1 $? "Body not matches pattern and matches NOT pattern - FAIL"

echo $((i+=1))
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PULL_REQUEST_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
pr_comparison
assert_eq 0 $? "Body not matches NOT pattern - match"
