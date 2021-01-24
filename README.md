# actions-pr-checker
Github Action to check PR title/description/labels. Feature rich and flexible.

Validation strings are regular expressions. Don't forget to escape special chars.
Comparison of substrings for title and description is done in bash using built-in `~=` operator. 

Labels are strictly checked to be equal - not as a substring nor a regexp.

## Quick start:
```yml
name: PR checker

on:
  pull_request:
    branches: [master, main]
    types: [opened, edited, labeled, unlabeled, synchronize]

jobs:
  pr-checker:

    name: Check PR description
    runs-on: [ubuntu-latest]
    steps:

      - name: Run check
        uses: transferwise/actions-pr-checker@v3
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          PR_NOT_CONTAINS_PATTERN: 'Why is this PR necessary?'
          PR_COMMENT: 'Please check description. \nShould be meaningful and not empty.'
```

## Parameters
| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
|GITHUB_TOKEN | github bot token | | yes |
|PR_CONTAINS_PATTERN | Regexp to validate PR body | `.*` | no
|PR_NOT_CONTAINS_PATTERN | Regexp to validate PR body | `pseudo-long-string-constant` | no |
|PR_TITLE_CONTAINS_PATTERN | Regexp to validate PR title | `.*` | no
|PR_TITLE_NOT_CONTAINS_PATTERN | Regexp to validate PR title | `pseudo-long-string-constant` | | 
|PR_TAGS_MANDATORY | Should have at least 1 tag from the list. Use JSON format in single quotes: '["bug", "feature"]' | `` | | 
|PR_TAGS_MIN_COUNT | Minimum number of tags | `0` | |
|PR_TAGS_RESTRICTED | Allow only tags from the list. If empty - allow everything | `` | | 
|PR_COMMENT | Comment to add, if validation not passing| `Please check description. \nShould be meaningful and not empty.` | |
|SUCCESS_EMOJI | Reaction to PR if check success. Possible: `+1` `-1` `laugh` `confused` `heart` `hooray` `rocket` `eyes` (ref: https://developer.github.com/v3/reactions/#reaction-types). If empty - no reaction | `+1` |  |
|SUCCESS_COMMENT | Add comment if check success. If empty - no comment | `` |  |
|SUCCESS_APPROVES_PR | Approve PR when check pass. If set to `false` won't request changes, but add comments instead | true | |
|FAIL_CLOSES_PR | Close PR in case of check fails | false | |
|FAIL_EXITS | Fail the check if validation not passing. Use `false` if you want comment, but mark as check as success | true | |


## More examples
### Check PR description is longer than 100 chars
```yaml
      - name: Run check
        uses: transferwise/actions-pr-checker@v3
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          PR_CONTAINS_PATTERN: '.{100,}'
```
### Check PR title complies with convention
```yaml
      - name: Check PR title
        uses: transferwise/actions-pr-checker@v3
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          PR_TITLE_CONTAINS_PATTERN: '.*(\\w{3})-([0-9]+).+[^.]$'
          PR_COMMENT: |
            Please check PR title.
            Should follow https://namingconvention.org/git/pull-request-naming.html.
```
### Check PR labels are set
```yaml
      - name: Run check
        uses: transferwise/actions-pr-checker@v3
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          PR_TAGS_MANDATORY: '["change:standard", "change:impactful", "change:emergency", "bug"]'
          PR_COMMENT: "Make sure you added required tags"
```
