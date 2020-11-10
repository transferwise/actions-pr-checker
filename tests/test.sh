#!/bin/bash

GITHUB_TOKEN='fake'
GITHUB_REPOSITORY='fake'
GITHUB_EVENT_PATH='fake'
GITHUB_EVENT_NAME='fake'

ERR="Assertion failed"

DIR=$(dirname "$0")
source "${DIR}/../defaults.sh"
source "${DIR}/../comparison.sh"
source "${DIR}/assert.sh"


echo $((i+=1))
echo "Nothing set - OK"
GITHUB_PULL_REQUEST_EVENT_BODY=""
pr_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Nothing set, body not empty - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Something"
pr_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body not matches pattern - FAIL"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello"
PULL_REQUEST_CONTAINS_PATTERN=".{20,}"
pr_comparison
assert_eq 1 $? "$ERR"

echo $((i+=1))
echo "Body matches pattern - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PULL_REQUEST_CONTAINS_PATTERN="\[TICKET\]"
pr_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body matches pattern case insensitive - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Fixing [Ticket]"
PULL_REQUEST_CONTAINS_PATTERN="\[TICKET\]"
pr_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body matches pattern and NOT pattern - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PULL_REQUEST_CONTAINS_PATTERN="\[TICKET\]"
PULL_REQUEST_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
pr_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body not matches pattern and matches NOT pattern - FAIL"
GITHUB_PULL_REQUEST_EVENT_BODY="This is default text.\n Why is this PR necessary?\nAdd text."
PULL_REQUEST_CONTAINS_PATTERN="\[TICKET\]"
PULL_REQUEST_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
pr_comparison
assert_eq 1 $? "$ERR"

echo $((i+=1))
echo "Body not matches NOT pattern - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PULL_REQUEST_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
pr_comparison
assert_eq 0 $? "$ERR"
