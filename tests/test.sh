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


# TESTS PR BODY

echo $((i+=1))
echo "Nothing set - OK"
GITHUB_PULL_REQUEST_EVENT_BODY=""
body_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Nothing set, body not empty - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Something"
body_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body not matches pattern - FAIL"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello"
PR_CONTAINS_PATTERN=".{20,}"
body_comparison
assert_eq 1 $? "$ERR"

echo $((i+=1))
echo "Body matches pattern - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PR_CONTAINS_PATTERN="\[TICKET\]"
body_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body matches pattern case insensitive - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Fixing [Ticket]"
PR_CONTAINS_PATTERN="\[TICKET\]"
body_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body matches pattern and NOT pattern - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PR_CONTAINS_PATTERN="\[TICKET\]"
PR_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
body_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body not matches pattern and matches NOT pattern - FAIL"
GITHUB_PULL_REQUEST_EVENT_BODY="This is default text.\n Why is this PR necessary?\nAdd text."
PR_CONTAINS_PATTERN="\[TICKET\]"
PR_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
body_comparison
assert_eq 1 $? "$ERR"

echo $((i+=1))
echo "Body not matches NOT pattern - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PR_NOT_CONTAINS_PATTERN=".*Why is this PR necessary?.*"
body_comparison
assert_eq 0 $? "$ERR"


# TEST PR TITLE
source "${DIR}/../defaults.sh"

echo $((i+=1))
echo "Nothing set - OK"
GITHUB_PULL_REQUEST_EVENT_TITLE=""
title_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Nothing set, title not empty - OK"
GITHUB_PULL_REQUEST_EVENT_TITLE="Something"
title_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Pattern set, title matches pattern - OK"
GITHUB_PULL_REQUEST_EVENT_TITLE="CLS-23 Add Edit on Github button to all the pages"
PR_TITLE_CONTAINS_PATTERN=".*(\\w{3})-([0-9]+).+[^.]$"
title_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Pattern set, title not matches pattern - FAIL"
GITHUB_PULL_REQUEST_EVENT_TITLE="Add Edit on Github button to all the pages."
PR_TITLE_CONTAINS_PATTERN=".*(\\w{3})-([0-9]+).+[^.]$"
title_comparison
assert_eq 1 $? "$ERR"

echo $((i+=1))
echo "Title not matches NOT pattern - FAIL"
GITHUB_PULL_REQUEST_EVENT_TITLE="Add Edit on Github button to all the pages."
PR_TITLE_CONTAINS_PATTERN=".*"
PR_TITLE_NOT_CONTAINS_PATTERN="Github"
title_comparison
assert_eq 1 $? "$ERR"

echo $((i+=1))
echo "Title not matches both patterns - FAIL"
GITHUB_PULL_REQUEST_EVENT_TITLE="Oranges for christmas"
PR_TITLE_CONTAINS_PATTERN="apples"
PR_TITLE_NOT_CONTAINS_PATTERN="oranges"
title_comparison
assert_eq 1 $? "$ERR"


# TEST BODY AND TITLE CHECKS
echo $((i+=1))
echo "Body ok, title ok - OK"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PR_CONTAINS_PATTERN="ticket"
PR_NOT_CONTAINS_PATTERN="oranges"
GITHUB_PULL_REQUEST_EVENT_TITLE="Add Edit on Github button."
PR_TITLE_CONTAINS_PATTERN="github"
PR_TITLE_NOT_CONTAINS_PATTERN="oranges"
body_comparison && title_comparison
assert_eq 0 $? "$ERR"

echo $((i+=1))
echo "Body ok, title fail - FAIL"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PR_CONTAINS_PATTERN="ticket"
PR_NOT_CONTAINS_PATTERN="oranges"
GITHUB_PULL_REQUEST_EVENT_TITLE="Add Edit on Github button"
PR_TITLE_CONTAINS_PATTERN="[0-9]{3}"
PR_TITLE_NOT_CONTAINS_PATTERN="oranges"
body_comparison && title_comparison
assert_eq 1 $? "$ERR"

echo $((i+=1))
echo "Body fail, title ok - FAIL"
GITHUB_PULL_REQUEST_EVENT_BODY="Hello, fixing [TICKET] and [OTHER]"
PR_CONTAINS_PATTERN="ticket"
PR_NOT_CONTAINS_PATTERN="other"
GITHUB_PULL_REQUEST_EVENT_TITLE="Add Edit on Github button"
PR_TITLE_CONTAINS_PATTERN="github"
PR_TITLE_NOT_CONTAINS_PATTERN="oranges"
body_comparison && title_comparison
assert_eq 1 $? "$ERR"
